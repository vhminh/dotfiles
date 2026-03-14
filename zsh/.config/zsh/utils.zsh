# Utility functions for .zshrc

# --- Eval cache ---
# Cache slow command output, regenerate per-file after 1 day.
# Usage: eval_cache <name> <command...>
eval_cache() {
  zmodload -F zsh/stat b:zstat 2>/dev/null
  local name=$1; shift
  local cache="$ZDOTDIR/cache/$name.zsh"
  mkdir -p "${cache:h}"
  if [[ ! -f $cache ]] || { local -A st; zstat -H st "$cache" && (( EPOCHSECONDS - st[mtime] > 86400 )); }; then
    "$@" > "$cache"
  fi
  source "$cache"
}

# --- Startup timing ---
__zshrc_record_init() {
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
}

__zshrc_record_deinit() {
  if [[ -o interactive ]]; then
    autoload -Uz add-zsh-hook

    __zshrc_report() {
      add-zsh-hook -d precmd __zshrc_report
      local -F dt=$(( EPOCHREALTIME - __zshrc_t0 ))
      if (( dt > 0.2 )); then
        print -r -- "⚠  zsh startup took ${dt}s (>0.2s). Breakdown:"
        print -l -- ${(On)__zshrc_timings}
      fi
      unset __zshrc_t0 __zshrc_t __zshrc_timings
      unfunction __zshrc_report 2>/dev/null
    }

    add-zsh-hook precmd __zshrc_report
  fi

  unfunction __zshrc_record_init __zshrc_record_deinit __zshrc_record_start __zshrc_record_end 2>/dev/null
}
