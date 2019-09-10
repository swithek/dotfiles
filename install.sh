#! /bin/bash

target=".."

if [ -n "$1" ]; then
	target="$1"
fi

for pack in $(ls -d */ | cut -f1 -d '/'); do
    stow -t $target "$pack"
done
