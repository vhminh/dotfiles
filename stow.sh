#!/bin/bash 

default="vim tmux alacritty bash"

if [[ $# -eq 0 ]]
then
	configs=$default
else
	configs=$@
fi

echo "Stow config for $configs"
stow --dir=. --target=$HOME --verbose --restow $configs 2>&1 | grep -v "BUG in find_stowed_path?"
echo "Done"

