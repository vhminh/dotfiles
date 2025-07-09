autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"

for file in $ZDOTDIR/rc/*.zsh; do
  source $file
done

for file in $ZDOTDIR/host_specific/*.zsh; do
  source $file
done

if [[ -f $ZDOTDIR/host_specific.zsh ]]; then
  source $ZDOTDIR/host_specific.zsh
fi
