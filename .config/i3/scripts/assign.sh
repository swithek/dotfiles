#!/bin/bash

nr=$1

if [ -z "$1" ]; then
	nr=8
fi

info=($(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | \
	awk "{print \$2}") | \
	sed -nE 's/^WM_CLASS.*= "(\w+)", "(\w+)"/\1\ \2/p'))

sed -i -E "/^assign.+class=\"${info[1]}\"/ d;
	0,/^assign/ s/^(assign)/assign\ [class=\"${info[1]}\"] \$ws$nr\n\1/" $HOME/.config/i3/config
