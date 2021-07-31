#!/bin/bash 

default="nvim X vim tmux alacritty bash"

if [[ $# -eq 0 ]]
then
	configs=$default
else
	configs=$@
fi

echo "Stow config for [$configs]"
stow --dir=. --target=$HOME --verbose --restow $configs
echo "Done"
