#!/bin/bash
# vim: set filetype=sh :



trap 'exit' INT # necessary bc otherwise just kills the running mgrep watch. Not the whole bash
cd /Users/evanthomas/notes/Main
while true; do
  timeout --foreground 3600 mgrep watch
done


# while true; do
#   mgrep watch &
#   pid=$!

#   ( sleep 3600; kill "$pid" ) &
#   killer=$!

#   wait "$pid"       # wait for mgrep to exit (naturally or via kill)
#   kill "$killer" 2>/dev/null || true  # cleanup in case mgrep exited early
# done
