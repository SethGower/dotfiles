[[ -f ~/.Xdefaults ]] && xrdb -merge -I$HOME ~/.Xdefaults
[[ -f ~/.xprofile ]] && source ~/.xprofile
[[ -x $(which wal) ]] && wal -R
xbindkeys &
exec i3
