HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname $HISTFILE)"
setopt extendedglob nomatch notify
bindkey -v
unsetopt autocd beep
setopt extended_history hist_ignore_all_dups
