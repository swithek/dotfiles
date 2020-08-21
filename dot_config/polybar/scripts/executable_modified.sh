#! /bin/bash

if [ -n "$(git -C "$(chezmoi source-path)" status --porcelain)" ]; then
	echo %{F#cc241d}%{F-}
	exit
fi

echo %{F#b8bb26}%{F-}
