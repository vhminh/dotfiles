# --- Startup profiling setup (wall-clock, per-file) ---
zmodload zsh/zprof
if [[ -o interactive ]]; then
  zmodload zsh/datetime 2>/dev/null
  typeset -gF __zshrc_t0=$EPOCHREALTIME
  typeset -gF __zshrc_t=$EPOCHREALTIME
  typeset -ga __zshrc_timings=()
  __zshrc_record_start() {
    __zshrc_t=$EPOCHREALTIME
  }
  __zshrc_record_end() {
    __zshrc_timings+=("$(printf '%7.2fms  %s' $(( (EPOCHREALTIME - $__zshrc_t) * 1000 )) "$1")")
  }
else
  __zshrc_record_start() { :; }
  __zshrc_record_end() { :; }
fi

# --- Completion ---
__zshrc_record_start
autoload -Uz compinit
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
if [[ -n $zcompdump(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi
__zshrc_record_end "compinit"

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- Source config files ---
for file in $ZDOTDIR/.zshrc.d/*.zsh(N); do
  __zshrc_record_start
  source "$file"
  __zshrc_record_end "${file:t}"
done

for file in $ZDOTDIR/local.d/*.zsh(N); do
  __zshrc_record_start
  source "$file"
  __zshrc_record_end "${file:t}"
done

# --- Report slow startup at first prompt ---
if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook

  __zshrc_report() {
    add-zsh-hook -d precmd __zshrc_report
    local -F dt=$(( EPOCHREALTIME - __zshrc_t0 ))
    if (( dt > 0.3 )); then
      print -r -- "⚠  zsh startup took ${dt}s (>0.3s). Breakdown:"
      print -l -- ${(On)__zshrc_timings}
      zprof
    fi
    unset __zshrc_t0 __zshrc_t __zshrc_timings
    unfunction __zshrc_record_start __zshrc_record_end __zshrc_report 2>/dev/null
  }

  add-zsh-hook precmd __zshrc_report
fi
