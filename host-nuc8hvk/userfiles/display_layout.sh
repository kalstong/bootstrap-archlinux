#!/bin/sh

if [ "$1" = "single" ]; then
xrandr \
	--output DisplayPort-0 --off \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --off \
	--output DisplayPort-3 --off \
	--output HDMI-A-0 --off \
	--output HDMI-A-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal

elif [ "$1" = "dual" ]; then
xrandr \
	--output DisplayPort-0 --off \
	--output DisplayPort-1 --off \
	--output DisplayPort-2 --mode 2560x1440 --pos 2560x0 --rotate left \
	--output DisplayPort-3 --off \
	--output HDMI-A-0 --off \
	--output HDMI-A-1 --primary --mode 2560x1440 --pos 0x254 --rotate normal
fi
