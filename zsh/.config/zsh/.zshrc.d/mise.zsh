if command -v mise >/dev/null 2>&1; then
  source <(mise activate zsh)
  # source <(mise hook-env -s zsh)
  source <(mise completion zsh)
fi

