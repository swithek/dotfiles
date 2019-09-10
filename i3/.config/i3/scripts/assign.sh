#!/bin/bash

nr=8

if [ -n "$1" ]; then
	nr=$1
fi

info=($(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | \
	awk "{print \$2}") | \
	sed -nE 's/^WM_CLASS.*= "([_a-zA-Z0-9-]+)", "([_a-zA-Z0-9-]+)"/\1\ \2/p'))

sed -i -E "/^assign.+class=\"${info[1]}\" instance=\"${info[0]}\"/ d;
	0,/^assign/ s/^(assign)/assign\ [class=\"${info[1]}\" instance=\"${info[0]}\"] \$ws$nr\n\1/"\
		$HOME/.config/i3/config
