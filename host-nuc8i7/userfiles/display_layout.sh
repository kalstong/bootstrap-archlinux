#!/bin/sh

if [ "$1" = "solo" ]; then
xrandr \
	--output DP1 --off \
	--output DP2 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
	--output HDMI1 --off \
	--output VIRTUAL1 --off

elif [ "$1" = "dual" ]; then
xrandr \
	--output DP1 --mode 2560x1440 --pos 0x0 --rotate normal \
	--output DP2 --left-of DP1 --mode 2560x1440 --pos 0x0 --rotate normal \
	--output HDMI1 --off \
	--output VIRTUAL1 --off
fi
