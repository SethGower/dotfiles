#!/bin/bash
STATE=$(cat ./.state)

if [ $STATE == 'public' ]; then
	echo $(curl --limit-rate 1k -s ipinfo.io/ip)
    echo "private" > ./.state
else
	echo $(ip a | grep $NETWORK_INTERFACE | grep 'inet' | cut -d '/' -f1 | cut -d 't' -f2 | cut -d ' ' -f2)
    echo "public" > ./.state
fi
