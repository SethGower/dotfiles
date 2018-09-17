#!/bin/bash
STATE=$(cat /tmp/polybar-ip-state)

public=$(curl --limit-rate 1k -s ipinfo.io/ip)
private=$(ip a | awk '/secondary/{print $2}' | cut -d '/' -f1)

if [ $public == $private ]; then
	echo $public
else
	if [ $STATE == 'public' ]; then
		echo Public: $public
		echo "private" >/tmp/polybar-ip-state
	else
		echo Private: $private
		echo "public" >/tmp/polybar-ip-state
	fi
fi
