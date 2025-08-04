if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # rustup
  if brew list --formula | grep -q rustup; then
    export PATH=$(brew --prefix rustup)/bin:$PATH
  fi

  # sdkman
  if brew list --formula | grep -q sdkman-cli; then
    export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  fi
fi

