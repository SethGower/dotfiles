#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
export POLYBAR_PRIMARY=$(xrandr -q | awk '/primary/{print $1}')
printf "[INFO] Starting polybar on primary monitor $POLYBAR_PRIMARY\n"
polybar -r top &
polybar -r bottom &

echo "Bars launched..."