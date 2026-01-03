if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # caching for better performance
  brew_prefix=$(brew --prefix)
  brew_installed_formulas=$(brew list --formula)

  # rustup
  if echo $brew_installed_formulas | grep -q rustup; then
    export PATH=${brew_prefix}/rustup/bin:$PATH
  fi

  # sdkman
  if echo $brew_installed_formulas | grep -q sdkman-cli; then
    export SDKMAN_DIR=${brew_prefix}/sdkman-cli/libexec
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  fi

  # mise
  if echo $brew_installed_formulas | grep -q mise; then
    eval "$(mise activate zsh)"
  fi
fi

