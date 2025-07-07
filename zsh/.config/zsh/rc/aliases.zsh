alias vi='\vim'
alias vim='nvim'
alias ls='ls --color=auto'
alias sudo='sudo '
alias k='kubectl'
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=$(which nvim)
  export VISUAL=$(which nvim)
fi

if [[ $(uname -s) == "Linux" ]]; then
  alias open='xdg-open'
fi

