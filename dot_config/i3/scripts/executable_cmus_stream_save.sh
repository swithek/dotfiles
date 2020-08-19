#! /bin/bash

name=$(cmus-remote -Q | sed -nE 's/^stream (.+)/\1/p')

if [ -n "$name" ]; then
	if grep -ix "$name" $HOME/Music/stream_songs.txt; then
		notify-send "Stream saver" "Current stream song is already present in the list"
		exit
	fi

	echo "$name" >> $HOME/Music/stream_songs.txt
	notify-send "Stream saver" "Current stream song was saved successfully"
	exit
fi

notify-send "Stream saver" "No stream or song was found"
