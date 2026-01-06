if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # rustup
  if [[ -d "$HOMEBREW_PREFIX/opt/rustup" ]]; then
    export PATH=$HOMEBREW_PREFIX/opt/rustup/bin:$PATH
  fi

  # sdkman
  if [[ -d "$HOMEBREW_PREFIX/opt/sdkman-cli" ]]; then
    export SDKMAN_DIR=$HOMEBREW_PREFIX/opt/sdkman-cli/libexec
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  fi
fi

