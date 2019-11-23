[[ -f ~/.Xdefaults ]] && xrdb -merge -I$HOME ~/.Xdefaults
[[ -f ~/.xprofile ]] && source ~/.xprofile
#[[ $(hostname) -e "odyssey" ]] && exec mons -e left &
[[ -x $(which wal) ]] && wal -R
[[ -x $(which setxkbmap) ]] && setxkbmap -option "caps:swapescape"
exec i3
