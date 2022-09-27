#!/bin/sh

if [ "$1" = "single" ]; then
xrandr \
	--output DisplayPort-0 --off \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --off \
	--output eDP --primary --mode 1920x1080 --pos 0x1440 --rotate normal

elif [ "$1" = "office" ]; then
xrandr \
	--output DisplayPort-0 --mode 2560x1440 --pos 1920x0 --rotate normal \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --off \
	--output eDP --primary --mode 1920x1080 --pos 0x1169 --rotate normal

elif [ "$1" = "home" ]; then
xrandr \
	--output DisplayPort-0 --mode 2560x1440 --pos 0x0 --rotate normal \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --off \
	--output eDP --primary --mode 1920x1080 --pos 2560x0 --rotate normal
fi
fi

