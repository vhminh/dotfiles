if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # rustup
  if [[ -d "$HOMEBREW_PREFIX/opt/rustup" ]]; then
    export PATH=$HOMEBREW_PREFIX/opt/rustup/bin:$PATH
  fi
fi

