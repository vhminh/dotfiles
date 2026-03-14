if [[ "$OSTYPE" == linux* ]]; then
  if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startxfce4
  fi
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi

