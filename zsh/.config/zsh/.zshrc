# --- Utils ---
source "$ZDOTDIR/utils.zsh"
__zshrc_record_init

# --- Completion ---
__zshrc_record_start
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh
[[ -d $HOMEBREW_PREFIX/share/zsh-completions ]] && fpath+=$HOMEBREW_PREFIX/share/zsh-completions
autoload -Uz compinit
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
# Key the dump on the fpath so different launchers (Alacritty, JetBrains) each
# get their own cache instead of invalidating one another on every switch.
typeset -U fpath
str_hash $fpath
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION-$REPLY"
if [[ -n $zcompdump(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi
__zshrc_record_end "compinit"

# --- PATH ---
typeset -U path fpath
path=("$HOME/.local/bin" $path)

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

# --- Cleanup ---
__zshrc_record_deinit
