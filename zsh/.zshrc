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
export PATH=$(brew --prefix rustup)/bin:$PATH

function code() {
  dir=$(ls -d ~/Code/*/ | fzf)
  if [ $? -eq 0 ]; then
    cd $dir
  fi
}

if [[ $(uname -s) == "Darwin" ]]; then
  function intellij() {
    ls -d ~/Code/*/ | fzf | xargs /Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea > /dev/null 2>&1
  }
fi

# source machine specific rc
if [ -f ~/.zshcustomrc ]; then
  source ~/.zshcustomrc
fi
