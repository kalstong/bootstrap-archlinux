#!/bin/sh

if [ "$1" = "solo" ]; then
xrandr --output HDMI-A-4 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
       --output HDMI-A-3 --off \
       --output DisplayPort-2 --off \
       --output DisplayPort-3 --off \
       --output DisplayPort-4 --off \
       --output DisplayPort-5 --off
fi
