#!/usr/bin/env sh
# Fuzzy create/switch to a session from ~/Code or ~/repos directories
{ ls -d ~/Code/*/ ~/repos/*/ ; } 2>/dev/null | sed 's/\/$//' |
  fzf -m --header='Create new session' |
  awk -F/ '{print $NF, $0}' |
  xargs -r -n 2 sh -c '
    tmux has-session -t "=$1" 2>/dev/null || tmux new-session -ds "$1" -c "$2"
    tmux switch-client -t "$1"
  ' _
