HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch notify
unsetopt autocd beep
bindkey -v

autoload -U colors && colors
PS1="%{$fg[green]%}> %{$reset_color%}"
RPROMPT="%~"

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias ls='ls --color=auto'
export EDITOR=$(which nvim)
export VISUAL=$(which nvim)

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

