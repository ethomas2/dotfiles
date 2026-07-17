#!/bin/bash
# vim: set filetype=sh :

set -uo pipefail

# launchctl-spawned tmux panes are non-login shells with a bare PATH,
# so claude (and tools it shells out to) need to be made discoverable.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

MARKER="$HOME/.cache/sync-skills-daily.next"
INTERVAL=$((24 * 60 * 60))
POLL=$((30 * 60))

mkdir -p "$(dirname "$MARKER")"

trap 'exit' INT
while true; do
  next=$(cat "$MARKER" 2>/dev/null || echo 0)
  now=$(date +%s)
  if (( now >= next )); then
    echo "Running /sync-skills $(date '+%Y-%m-%d %H:%M:%S')"
    claude -p --allow-dangerously-skip-permissions "/sync-skills"
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
