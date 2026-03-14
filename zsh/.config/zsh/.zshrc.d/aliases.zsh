alias vi='\vim'
alias vim='nvim'
alias ls='ls --color=auto'
alias sudo='sudo '
alias k='kubectl'
if (( $+commands[nvim] )); then
  export EDITOR=nvim
  export VISUAL=nvim
fi

if [[ "$OSTYPE" == linux* ]]; then
  alias open='xdg-open'
fi

