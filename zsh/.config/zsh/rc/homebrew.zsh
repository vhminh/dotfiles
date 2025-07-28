if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command -v brew >/dev/null 2>&1; then
  # rustup
  if command -v rustup >/dev/null 2>&1; then
    export PATH=$(brew --prefix rustup)/bin:$PATH
  fi

  # sdkman
  if command -v sdk >/dev/null 2>&1; then
    export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  fi
fi

