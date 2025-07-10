function Code() {
  dir=$(ls -d ~/(Code|repos)/*/ | fzf)
  if [ $? -eq 0 ]; then
    cd $dir
  fi
}

if [[ $(uname -s) == "Darwin" ]]; then
  function intellij() {
    ls -d ~/(Code|repos)/*/ | fzf | xargs /Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea > /dev/null 2>&1
  }
fi

