#!/usr/bin/env sh
# Fuzzy kill tmux sessions
tmux ls | cut -d ':' -f1 | fzf -m --header='Kill session' | xargs -L 1 -r tmux kill-session -t
