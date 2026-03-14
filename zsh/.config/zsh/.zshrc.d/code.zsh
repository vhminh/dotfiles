function Code() {
  local dir
  dir=$(printf '%s\n' ~/(Code|repos)/*(/N) | fzf) || return
  cd "$dir"
}

if [[ "$OSTYPE" == darwin* ]]; then
  function intellij() {
    local dir
    dir=$(printf '%s\n' ~/(Code|repos)/*(/N) | fzf) || return
    /Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea "$dir" > /dev/null 2>&1
  }
fi

