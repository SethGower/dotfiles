#!/usr/bin/env sh


# Launch bar1 and bar2
export POLYBAR_PRIMARY=$(xrandr -q | awk '/primary/{print $1}')
export POLYBAR_SECONDARY=$(xrandr -q | awk '/ connected/ && !/primary/{print $1}' | grep --invert-match 'eDP')

# shift
printf "[INFO] Starting bars $@\n"
for bar in $@; do
    polybar -r $bar &
done

# polybar -r top-secondary &
echo "Bars launched..."
