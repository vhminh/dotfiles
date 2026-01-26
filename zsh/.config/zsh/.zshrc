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
