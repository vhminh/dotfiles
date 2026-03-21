#!/usr/bin/env sh
# Fuzzy switch to an existing tmux session
tmux ls | cut -d ':' -f1 | fzf --header='Switch session' | xargs -r tmux switch-client -t
