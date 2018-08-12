#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
MONITOR="eDP1" polybar -r top &
MONITOR="eDP1" polybar -r bottom &

MONITOR="HDMI1" polybar -r top-secondary &
MONITOR="HDMI2" polybar -r top-secondary &
MONITOR="HDMI1" polybar -r bottom &
MONITOR="HDMI2" polybar -r bottom &

echo "Bars launched..."
