#!/bin/bash
# vim: set filetype=sh :

set -uo pipefail

# launchctl-spawned tmux panes are non-login shells with a bare PATH,
# so brew (and tools it shells out to) need to be made discoverable.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

MARKER="$HOME/.cache/brew-upgrade-daily.next"
INTERVAL=$((24 * 60 * 60))
POLL=$((30 * 60))

mkdir -p "$(dirname "$MARKER")"

trap 'exit' INT
while true; do
  next=$(cat "$MARKER" 2>/dev/null || echo 0)
  now=$(date +%s)
  if (( now >= next )); then
    echo "Running brew update + upgrades $(date '+%Y-%m-%d %H:%M:%S')"
    (
      set -e
      brew update
      brew upgrade claude-code
      brew upgrade codex
    )
    status=$?
    if [[ "$status" -eq 0 ]]; then
      echo "OK $(date '+%Y-%m-%d %H:%M:%S')"
    else
      echo "FAILED $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    echo $(($(date +%s) + INTERVAL)) > "$MARKER"
  fi
  sleep "$POLL"
done
