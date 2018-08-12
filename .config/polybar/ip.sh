#!/bin/bash
public=$(curl --limit-rate 1k -s ipinfo.io/ip)
private=$(ip a | grep 'wlp4s0' | grep 'inet' | cut -d '/' -f1 | cut -d 't' -f2 | cut -d ' ' -f2)

if [[ "$public" == "$private" ]]; then
    echo $public
else
    echo "$private, $public"
fi
