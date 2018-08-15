#!/bin/bash
STATE=$(cat /tmp/polybar-ip-state)

if [ $STATE == 'public' ]; then
	echo Public: $(curl --limit-rate 1k -s ipinfo.io/ip)
	echo "private" >/tmp/polybar-ip-state
else
	echo Private: $(ip a | grep $NETWORK_INTERFACE | grep 'inet' | cut -d '/' -f1 | cut -d 't' -f2 | cut -d ' ' -f2)
	echo "public" >/tmp/polybar-ip-state
fi
