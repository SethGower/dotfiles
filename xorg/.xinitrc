exec i3
[[ -f ~/.Xdefaults ]] && xrdb -merge -I$HOME ~/.Xdefaults
[[ -f ~/.xprofile ]] && source ~/.xprofile
[[ $(hostname) -e "odyssey" ]] && exec mons -e left &
