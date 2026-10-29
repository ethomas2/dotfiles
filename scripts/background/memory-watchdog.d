#!/bin/bash
# memory-watchdog: logs a memory snapshot every 5 minutes (every minute when memory is tight) and
# alerts early when the Mac starts running out of memory. It never kills anything.
#
# Alerts (each reason at most once per 20 min, sooner if swap grew 4 GB since the last alert):
#   - kernel memory pressure is warn or critical
#   - swap used > 8 GB
#   - free memory < 15%
#   - one process's footprint (RAM + compressed) > 4 GB
#
# Logs, kept forever for later debugging:
#   ~/Library/Logs/memory-watchdog/YYYY-MM.log    full snapshots (top processes with full command
#                                                  and working directory, totals per app, docker)
#   ~/Library/Logs/memory-watchdog/metrics.jsonl  one summary line per snapshot, for graphing
set -uo pipefail
trap 'exit' INT

# tmux panes spawned by launchd are non-login shells; set PATH explicitly.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/scripts:$PATH"

LOG_DIR="$HOME/Library/Logs/memory-watchdog"
STATE_DIR="$HOME/.cache/memory-watchdog"
mkdir -p "$LOG_DIR" "$STATE_DIR"

CHECK_EVERY_S=60
SNAPSHOT_EVERY_S=300
ALERT_COOLDOWN_S=1200
SWAP_ALERT_MB=8192
FREE_PCT_ALERT=15
PROCESS_ALERT_MB=4096
TOP_N=20

# Reads the machine-wide numbers into globals: PRESSURE (normal|warn|critical), FREE_PCT, SWAP_USED_MB.
read_vitals() {
  case "$(sysctl -n kern.memorystatus_vm_pressure_level 2>/dev/null)" in
    2) PRESSURE=warn ;;
    4) PRESSURE=critical ;;
    *) PRESSURE=normal ;;
  esac
  FREE_PCT="$(memory_pressure 2>/dev/null | awk -F': ' '/free percentage/ {gsub("%", "", $2); print $2}')"
  FREE_PCT="${FREE_PCT:-100}"
  SWAP_USED_MB="$(sysctl -n vm.swapusage | awk '{for (i = 1; i <= NF; i++) if ($i == "used") {v = $(i + 2); sub("M", "", v); printf "%d", v}}')"
  SWAP_USED_MB="${SWAP_USED_MB:-0}"
}

# Prints "pid footprint_mb compressed_mb short_name" for the top processes by footprint.
top_processes() {
  top -l 1 -o mem -n "$TOP_N" -stats pid,mem,cmprs,command 2>/dev/null |
    awk '
      function mb(v) { u = substr(v, length(v)); n = v + 0
        if (u == "G") return n * 1024; if (u == "M") return n; if (u == "K") return n / 1024; return n / 1048576 }
      found && NF >= 4 { name = $4; for (i = 5; i <= NF; i++) name = name " " $i; printf "%s %d %d %s\n", $1, mb($2), mb($3), name }
      $1 == "PID" { found = 1 }'
}

# Appends one full snapshot to this month's log and one summary line to metrics.jsonl.
write_snapshot() {
  local reason="$1" now log procs
  now="$(date '+%Y-%m-%dT%H:%M:%S%z')"
  log="$LOG_DIR/$(date +%Y-%m).log"
  procs="$(top_processes)"
  {
    echo "===== $now ($reason) ====="
    echo "pressure=$PRESSURE free_pct=$FREE_PCT swap_used_mb=$SWAP_USED_MB $(sysctl -n vm.swapusage)"
    echo "ram_gb=$(($(sysctl -n hw.memsize) / 1073741824)) uptime=$(uptime | sed 's/.*up //; s/, [0-9]* user.*//')"
    echo "-- top $TOP_N by footprint (MB): pid footprint compressed | elapsed | command | cwd"
    while read -r pid fp cmp _; do
      [[ -z "$pid" ]] && continue
      printf '%6s %7s %7s | %s | %s | %s\n' "$pid" "$fp" "$cmp" \
        "$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ')" \
        "$(ps -o command= -p "$pid" 2>/dev/null | cut -c1-300)" \
        "$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | awk '/^n/ {print substr($0, 2)}')"
    done <<<"$procs"
    echo "-- resident MB summed by executable (top 12)"
    ps -axo rss=,comm= | awk '{s[$2] += $1} END {for (k in s) printf "%8d %s\n", s[k] / 1024, k}' | sort -rn | head -12
    echo "-- docker containers"
    timeout 15 docker stats --no-stream --format '{{.Name}} {{.MemUsage}} {{.CPUPerc}}' 2>/dev/null || echo "(docker unavailable)"
    echo
  } >>"$log"
  local top5
  top5="$(head -5 <<<"$procs" | awk '{printf "%s{\"pid\":%s,\"mb\":%s,\"name\":\"%s\"}", (NR > 1 ? "," : ""), $1, $2, $4}')"
  printf '{"ts":"%s","reason":"%s","pressure":"%s","free_pct":%s,"swap_used_mb":%s,"top":[%s]}\n' \
    "$now" "$reason" "$PRESSURE" "$FREE_PCT" "$SWAP_USED_MB" "$top5" >>"$LOG_DIR/metrics.jsonl"
}

# Gzips monthly logs from earlier months so they stay around but small.
compress_old_logs() {
  local this_month
  this_month="$(date +%Y-%m).log"
  for f in "$LOG_DIR"/*.log; do
    [[ -e "$f" && "$(basename "$f")" != "$this_month" ]] && gzip -q "$f"
  done
}

# Prints the alert reasons that hold right now, one per line, as "key|message".
alert_reasons() {
  [[ "$PRESSURE" != normal ]] && echo "pressure|memory pressure $PRESSURE"
  ((SWAP_USED_MB > SWAP_ALERT_MB)) && echo "swap|swap $((SWAP_USED_MB / 1024)) GB used"
  ((FREE_PCT < FREE_PCT_ALERT)) && echo "free|only ${FREE_PCT}% memory free"
  # Docker's VM holds its configured memory by design, so it doesn't count as a runaway process.
  top_processes | awk -v lim="$PROCESS_ALERT_MB" '$2 > lim && $4 !~ /^com\.apple\.Virtua/ {printf "proc-%s|%s (pid %s) at %.1f GB\n", $1, $4, $1, $2 / 1024}'
}

# Sends one alert per reason, respecting the cooldown unless swap grew a lot since the last alert.
maybe_alert() {
  local reasons="$1" now fired=() key msg last last_swap
  now="$(date +%s)"
  while IFS='|' read -r key msg; do
    [[ -z "$key" ]] && continue
    last="$(cat "$STATE_DIR/$key.last" 2>/dev/null || echo 0)"
    last_swap="$(cat "$STATE_DIR/$key.swap" 2>/dev/null || echo 0)"
    if ((now - last >= ALERT_COOLDOWN_S || SWAP_USED_MB - last_swap >= 4096)); then
      echo "$now" >"$STATE_DIR/$key.last"
      echo "$SWAP_USED_MB" >"$STATE_DIR/$key.swap"
      fired+=("$msg")
    fi
  done <<<"$reasons"
  ((${#fired[@]} == 0)) && return
  local top3
  top3="$(top_processes | head -3 | awk '{printf "%s%s %.1fG", (NR > 1 ? ", " : ""), $4, $2 / 1024}')"
  local text
  text="Memory: $(printf '%s; ' "${fired[@]}" | sed 's/; $//'). Top: $top3"
  alert "${text:0:200}" --open "file://$LOG_DIR/$(date +%Y-%m).log" || true
  echo "$(date '+%H:%M:%S') ALERT $text"
}

last_snapshot=0
while true; do
  read_vitals
  reasons="$(alert_reasons)"
  now="$(date +%s)"
  interval="$SNAPSHOT_EVERY_S"
  [[ -n "$reasons" ]] && interval="$CHECK_EVERY_S"
  if ((now - last_snapshot >= interval)); then
    write_snapshot "$([[ -n "$reasons" ]] && echo elevated || echo routine)"
    compress_old_logs
    last_snapshot="$now"
    echo "$(date '+%H:%M:%S') snapshot pressure=$PRESSURE free=${FREE_PCT}% swap=$((SWAP_USED_MB / 1024))G"
  fi
  [[ -n "$reasons" ]] && maybe_alert "$reasons"
  sleep "$CHECK_EVERY_S"
done
