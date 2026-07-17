#!/bin/bash
# vim: set filetype=sh :

set -uo pipefail

# launchctl-spawned tmux panes are non-login shells with a bare PATH,
# so brew, claude, and tools they shell out to need to be made discoverable.
# ~/.local/bin holds the native claude install (~/.local/bin/claude → versions/X.Y.Z).
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

POLL=$((5 * 60))  # wake every 5 minutes
INTERVAL=$((60 * 60)) # When you wake, if it's been 1h since the last update, update

trap 'exit' INT
next=0
while true; do
  now=$(date +%s)
  echo "Waking $now ..."
  if (( now >= next )); then
    echo "Running brew update + upgrades $(date '+%Y-%m-%d %H:%M:%S')"
    (
      set -ex
      brew update
      brew upgrade codex
      # claude is NOT brew-managed — the Homebrew cask lags real releases by
      # days/weeks. Use the native self-updater instead. `claude update` is
      # a no-op when already on latest.
      claude update
    )
    status=$?
    if [[ "$status" -eq 0 ]]; then
      echo "OK $(date '+%Y-%m-%d %H:%M:%S')"
    else
      echo "FAILED $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    next=$(($(date +%s) + INTERVAL))
  fi
  sleep "$POLL"
done
