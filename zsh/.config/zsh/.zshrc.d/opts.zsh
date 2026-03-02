HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname $HISTFILE)"
setopt extendedglob nomatch notify
bindkey -v
unsetopt autocd beep
setopt extended_history hist_ignore_all_dups hist_ignore_space
setopt share_history hist_expire_dups_first hist_verify hist_reduce_blanks
