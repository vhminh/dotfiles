if (( $+commands[mise] )); then
  source <(mise activate zsh)
  eval_cache mise-completion mise completion zsh
fi

