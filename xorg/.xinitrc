[[ -f ~/.Xdefaults ]] && xrdb -merge -I$HOME ~/.Xdefaults
[[ -f ~/.xprofile ]] && source ~/.xprofile
[[ -x $(which wal) ]] && wal -R
exec i3
