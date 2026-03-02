# --- Startup profiling setup (wall-clock, per-file) ---
if [[ -o interactive ]]; then
  zmodload zsh/datetime 2>/dev/null
  typeset -gF __zshrc_t0=$EPOCHREALTIME
  typeset -ga __zshrc_timings=()
  __zshrc_record() {
    __zshrc_timings+=("$(printf '%7.2fms  %s' $(( (EPOCHREALTIME - $1) * 1000 )) "$2")")
  }
else
  __zshrc_record() { :; }
fi

# --- Completion ---
autoload -Uz compinit
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
local -F __zshrc_t=$EPOCHREALTIME
if [[ -n $zcompdump(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi
__zshrc_record $__zshrc_t compinit

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- Source config files ---
local -a __zshrc_files=(
  $ZDOTDIR/rc/*.zsh(N)
  $ZDOTDIR/host_specific/*.zsh(N)
)

for file in $__zshrc_files; do
  __zshrc_t=$EPOCHREALTIME
  source "$file"
  __zshrc_record $__zshrc_t "${file:t}"
done

# --- Report slow startup at first prompt ---
if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook

  __zshrc_report() {
    add-zsh-hook -d precmd __zshrc_report
    local -F dt=$(( EPOCHREALTIME - __zshrc_t0 ))
    if (( dt > 0.3 )); then
      print -r -- "⚠  zsh startup took ${dt}s (>0.4s). Breakdown:"
      print -l -- ${(On)__zshrc_timings}
    fi
    unset __zshrc_t0 __zshrc_timings
    unfunction __zshrc_record __zshrc_report 2>/dev/null
  }

  add-zsh-hook precmd __zshrc_report
fi
