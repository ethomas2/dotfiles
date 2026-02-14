#!/bin/bash
# vim: set filetype=sh :

set -uo pipefail

trap 'exit' INT # necessary bc otherwise just kills the running mgrep watch. Not the whole bash
cd /Users/evanthomas/notes/Main
while true; do
  NEW_COMMIT=""
  (
    set -e
    DATE=$(date '+%m/%d/%Y')
    git add .
    git commit -m "Update $DATE"
    git push
    NEW_COMMIT=$(git log  --oneline --decorate=no -1)
  ) >/dev/null
  if [[ "$?" -eq 0 ]]; then
    echo "Pushed $NEW_COMMIT"
  else
    echo "No new info :: $(date '+%Y/%m/%d %H:%M:%S')"
  fi
  sleep 3600
done
