if [[ $(uname -s) == "Linux" ]]; then
  if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startxfce4
  fi
fi

