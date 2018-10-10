unset TERMINAL
unset POLYBAR_PRIMARY
unset PRIMARY_TOP_LEFT PRIMARY_TOP_CENTER PRIMARY_TOP_RIGHT
unset PRIMARY_BOTTOM_LEFT PRIMARY_BOTTOM_CENTER PRIMARY_BOTTOM_RIGHT

if [[ -x "$HOME/.config/scripts/$(hostname).rc" ]]; then
	printf "[INFO] Sourcing ~/.config/scripts/$(hostname).rc\n"
	source $HOME/.config/scripts/$(hostname).rc
fi

if [[ $(hostname) == 'odyssey' ]]; then
	printf "[INFO] Setting HDMI1 to primary monitor\n"
	xrandr --output HDMI1 --primary
elif [[ $(hostname) == "daedalus" ]]; then
	printf "[INFO] Setting primary monitor to eDP1 and setting resolution to 1080p\n"
	xrandr --output eDP1 --mode 1920x1080
fi

# Kill everything
printf "[INFO] Stopping existing services\n"
services="polybar compton redshift-gtk"

for service in $services; do
	printf "  [INFO] Sending signal to all $service\n"
	killall $service
done
# Wait for them to die
for service in $services; do
	i=0
	while pgrep $service >/dev/null 2>&1; do
		if [[ "$i" == "10" ]]; then
			printf "  [INFO] Waited too long, killing $service with prejudice\n"
			killall -9 $service
		else
			printf "  [INFO] Waiting on $service\n"
			sleep 0.5
			i=$(expr $i + 1)
		fi
	done
	unset i
done

printf "  [INFO] Killing Caffeine\n"
kill -9 $(ps aux | awk '!/awk/ && /caffeine-ng/{print $2}')

printf "[INFO] Starting Services...\n"

# Compositor for transparency
printf "    [INFO] Starting compton\n"
compton &

# Bars
printf "    [INFO] Starting polybar\n"
$HOME/.config/polybar/launch.sh

# MY EYES!!!! Start redshift
printf "    [INFO] Starting redshift\n"
redshift-gtk -c $HOME/.config/redshift/$(hostname).conf

printf "    [INFO] Starting caffeine\n"
caffeine &

# Mons daemon to auto remove external monitors on laptop
if [[ $(hostname) == 'daedalus' ]]; then
	printf "    [INFO] Starting mons daemon\n"
	mons -a >/dev/null 2>&1 &
fi

printf "[INFO] Setting Wallpaper...\n"

if which feh >/dev/null 2>&1; then
	printf "    [INFO] Setting wallpaper with feh"
	feh --bg-scale $HOME/.dotfiles/background.png
fi

if [[ -x /usr/bin/numlockx ]]; then
	numlockx off
fi
