for file in $ZDOTDIR/rc/*.zsh; do
  source $file
done

if [[ -f $ZDOTDIR/host_specific.zsh ]]; then
  source $ZDOTDIR/host_specific.zsh
fi
