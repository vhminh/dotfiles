source "$ZDOTDIR/utils.zsh"

if [[ "$OSTYPE" == linux* ]]; then
  if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startxfce4
  fi
fi

if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
  eval_cache brew-shellenv "$HOMEBREW_PREFIX/bin/brew" shellenv
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi

