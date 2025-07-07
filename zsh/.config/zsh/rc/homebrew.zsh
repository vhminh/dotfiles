if command -v brew >/dev/null 2>&1 && command -v rustup >/dev/null 2>&1; then
  export PATH=$(brew --prefix rustup)/bin:$PATH
fi

