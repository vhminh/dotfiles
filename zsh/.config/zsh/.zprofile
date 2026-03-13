if [[ $(uname -s) == "Linux" ]]; then
  if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startxfce4
  fi
fi

if command -v mise >/dev/null 2>&1; then
  source <(mise activate zsh --shims)
fi

