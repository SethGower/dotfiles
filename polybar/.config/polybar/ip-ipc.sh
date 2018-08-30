#!/bin/bash
STATE=$(cat /tmp/polybar-ip-state)

public=$(curl --limit-rate 1k -s ipinfo.io/ip)
private=$(ip a | grep $NETWORK_INTERFACE | grep 'inet' | cut -d '/' -f1 | cut -d 't' -f2 | cut -d ' ' -f2)

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
