#!/bin/bash

if [ -d $HOME/.cache/i3lock/current ]; then
	exit
fi

betterlockscreen -u $HOME/.config/wallpapers/forest.png
