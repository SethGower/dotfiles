exec i3
[[ -f ~/.Xdefaults ]] && xrdb -merge -I$HOME ~/.Xdefaults
exec mons -e left
