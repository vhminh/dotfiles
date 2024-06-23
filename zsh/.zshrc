HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch notify
unsetopt autocd beep
bindkey -v

autoload -U colors && colors
PS1="%{$fg[green]%}> %{$reset_color%}"
RPROMPT="%~"

alias vi='\vim'
alias vim='nvim'
alias ls='ls --color=auto'
alias sudo='sudo '
alias k='kubectl'
export EDITOR=$(which nvim)
export VISUAL=$(which nvim)

if [[ $(uname -s) == "Linux" ]]; then
  alias open='xdg-open'
fi

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

# source machine specific rc
if [ -f ~/.zshcustomrc ]; then
  source ~/.zshcustomrc
fi
