if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
  eval_cache brew-shellenv "$HOMEBREW_PREFIX/bin/brew" shellenv

  # rustup
  if [[ -d "$HOMEBREW_PREFIX/opt/rustup" ]]; then
    export PATH=$HOMEBREW_PREFIX/opt/rustup/bin:$PATH
  fi
fi

