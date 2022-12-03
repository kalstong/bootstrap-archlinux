#!/bin/sh

if [ "$1" = "single" ]; then
xrandr \
	--output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
	--output HDMI2 --off \
	--output HDMI1 --off \
	--output DP1 --off \
	--output VIRTUAL1 --off

elif [ "$1" = "office" ]; then
xrandr \
	--output HDMI2 --mode 2560x1440 --pos 1920x0 --rotate normal \
	--output HDMI1 --off \
	--output DP1 --off \
	--output eDP1 --primary --mode 1920x1080 --pos 0x1169 --rotate normal

elif [ "$1" = "home" ]; then
xrandr \
	--output HDMI2 --mode 2560x1440 --pos 0x0 --rotate normal \
	--output HDMI1 --off \
	--output DP1 --off \
	--output eDP1 --primary --mode 1920x1080 --pos 2560x0 --rotate normal
fi
fi
