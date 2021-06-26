# [[ -e $HOME/.config/scripts/$(hostname).rc ]] && source $HOME/.config/scripts/$(hostname).rc
[[ -x $(which xbindkeys) ]] && xbindkeys &
[[ -x $(which light-locker) ]] && light-locker &
[[ -x $(which dunst) ]] && dunst &

# vim:ft=sh
