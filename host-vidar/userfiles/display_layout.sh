#!/bin/sh

if [ "$1" = "single" ]; then
xrandr \
	--output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
	--output DP1 --off \
	--output HDMI1 --off \
	--output VIRTUAL1 --off

elif [ "$1" = "dual" ]; then
xrandr \
	--output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
	--output DP1 --mode 2560x1440 --pos 2560x0 --rotate left \
	--output HDMI1 --off \
	--output VIRTUAL1 --off
fi
