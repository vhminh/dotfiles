# --- Startup timer + per-source wall-clock profiling ---
if [[ -o interactive ]]; then
  zmodload zsh/datetime 2>/dev/null
  typeset -gF __zshrc_t0=$EPOCHREALTIME
  typeset -gF __zshrc_ts=0
  typeset -ga __zshrc_timings=()
fi

autoload -Uz compinit
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

(( $+__zshrc_t0 )) && __zshrc_ts=$EPOCHREALTIME
if [[ -n $zcompdump(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi
(( $+__zshrc_t0 )) && __zshrc_timings+=("$(printf '%7.2fms  %s' $(( (EPOCHREALTIME - __zshrc_ts) * 1000 )) compinit)")

export PATH="$HOME/.local/bin:$PATH"

for file in $ZDOTDIR/rc/*.zsh; do
  (( $+__zshrc_t0 )) && __zshrc_ts=$EPOCHREALTIME
  source "$file"
  (( $+__zshrc_t0 )) && __zshrc_timings+=("$(printf '%7.2fms  %s' $(( (EPOCHREALTIME - __zshrc_ts) * 1000 )) "${file:t}")")
done

if [[ -d $ZDOTDIR/host_specific ]] then
  for file in $ZDOTDIR/host_specific/*.zsh; do
    (( $+__zshrc_t0 )) && __zshrc_ts=$EPOCHREALTIME
    source "$file"
    (( $+__zshrc_t0 )) && __zshrc_timings+=("$(printf '%7.2fms  %s' $(( (EPOCHREALTIME - __zshrc_ts) * 1000 )) "${file:t}")")
  done
fi

if [[ -f $ZDOTDIR/host_specific.zsh ]]; then
  (( $+__zshrc_t0 )) && __zshrc_ts=$EPOCHREALTIME
  source "$ZDOTDIR/host_specific.zsh"
  (( $+__zshrc_t0 )) && __zshrc_timings+=("$(printf '%7.2fms  %s' $(( (EPOCHREALTIME - __zshrc_ts) * 1000 )) host_specific.zsh)")
fi

# --- Only print profiling when startup is slow ---
if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook
  typeset -gF __zshrc_slow_threshold=0.4 # seconds

  __zshrc_maybe_print_zprof() {
    add-zsh-hook -d precmd __zshrc_maybe_print_zprof  # run once (first prompt)

    local -F dt=$(( EPOCHREALTIME - __zshrc_t0 ))
    if (( dt > __zshrc_slow_threshold )); then
      print -r -- "⚠️  zsh startup took ${dt}s (>${__zshrc_slow_threshold}s). Breakdown:"
      print -l -- ${(On)__zshrc_timings}
    fi
    unset __zshrc_t0 __zshrc_ts __zshrc_timings __zshrc_slow_threshold
  }

  add-zsh-hook precmd __zshrc_maybe_print_zprof
fi
