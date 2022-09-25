#!/bin/sh

if [ "$1" = "single" ]; then
xrandr \
	--output DisplayPort-0 --off \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
	--output DisplayPort-3 --off \
	--output HDMI-A-0 --off \
	--output HDMI-A-1 --off

elif [ "$1" = "dual" ]; then
xrandr \
	--output DisplayPort-0 --off \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
	--output DisplayPort-3 --off \
	--output HDMI-A-0 --off \
	--output HDMI-A-1 --right-of DisplayPort-2 --mode 2560x1440 --pos 0x0 --rotate normal
fi

