# --- Startup timer + enable zprof (function profiler) ---
if [[ -o interactive ]]; then
  zmodload zsh/datetime 2>/dev/null
  typeset -gF __zshrc_t0=$EPOCHREALTIME

  # Collect profiling data during startup
  zmodload zsh/zprof 2>/dev/null
fi

autoload -Uz compinit
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

export PATH="$HOME/.local/bin:$PATH"

for file in $ZDOTDIR/rc/*.zsh; do
  source $file
done

if [[ -d $ZDOTDIR/host_specific ]] then
  for file in $ZDOTDIR/host_specific/*.zsh; do
    source $file
  done
fi

if [[ -f $ZDOTDIR/host_specific.zsh ]]; then
  source $ZDOTDIR/host_specific.zsh
fi

# --- Only print zprof when startup is slow ---
if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook
  typeset -gF __zshrc_slow_threshold=0.4 # seconds

  __zshrc_maybe_print_zprof() {
    add-zsh-hook -d precmd __zshrc_maybe_print_zprof  # run once (first prompt)
    (( $+builtins[zprof] )) || return 0

    local -F dt=$(( EPOCHREALTIME - __zshrc_t0 ))
    if (( dt > __zshrc_slow_threshold )); then
      print -r -- "⚠️  zsh startup took ${dt}s (>${__zshrc_slow_threshold}s). zprof:"
      zprof
    fi
  }

  add-zsh-hook precmd __zshrc_maybe_print_zprof
fi
