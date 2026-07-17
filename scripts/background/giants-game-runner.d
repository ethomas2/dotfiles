#!/bin/bash
# vim: set filetype=sh :

set -uo pipefail

# launchctl-spawned tmux panes are non-login shells with a bare PATH.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

exec /Users/evanthomas/github.com/ethomas2/giants-game/scripts/giants-game-runner
