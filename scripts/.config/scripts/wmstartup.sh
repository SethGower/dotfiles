#!/bin/bash
unset TERMINAL
unset services

echo $(compgen -v | grep "POLYBAR")

if [[ -x "$HOME/.config/scripts/$(hostname).rc" ]]; then
    printf "[INFO] Sourcing ~/.config/scripts/$(hostname).rc\n"
    source $HOME/.config/scripts/$(hostname).rc
else
    printf "[ERROR] Unable to execute $(hotname).rc, this will prevent certain
    things like polybar and services being started"
fi

# Kill everything
printf "[INFO] Stopping existing services\n"

for service in $services; do
    printf "  [INFO] Sending signal to all $service\n"
    killall $service
done
# Wait for them to die
for service in $services; do
    i=0
    echo $service
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

printf "[INFO] Starting Services...\n"
start_services

# checks if dunst is installed
if [[ -n $(which dunst) ]];
then
    dunst &
fi

printf "[INFO] Setting Wallpaper\n"
set_wallpaper

[[ -x /usr/bin/numlockx ]] && numlockx off
