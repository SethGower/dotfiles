#!/bin/bash
if [[ -n $(pgrep light-locker) ]];
then
  light-locker-command -l
else
  rm /tmp/lock.png
  scrot -z /tmp/lock.png
  mogrify -resize 5% /tmp/lock.png
  mogrify -resize 2000% /tmp/lock.png
  amixer sset Master mute
  i3lock -i /tmp/lock.png &
  while true; do
      if [[ ! $(ps -e | grep i3lock) ]]; then
          break
      fi
  done
  amixer sset Master unmute
fi
