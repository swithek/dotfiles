#!/bin/bash

icon_color="#cc241d"
vpn_conn=$(nmcli c show --active | grep -i vpn)
if [ -n "$vpn_conn" ]; then
	icon_color="#b8bb26"
fi

info=""
ip_data=($(wget -qO - ifconfig.co/json | jq -r '.ip, .country'))
if [ -z "$1" ] || [ "$1" = '--ip' ]; then 
	info=${ip_data[0]}
elif [ "$1" = "--country" ]; then 
	info=${ip_data[*]:1}
fi

echo %{F$icon_color}%{F-} $info
