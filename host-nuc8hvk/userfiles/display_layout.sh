#!/bin/sh

if [ "$1" = "dual" ]; then
xrandr --output HDMI-A-3 --off \
       --output HDMI-A-4 --off \
       --output DisplayPort-2 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
       --output DisplayPort-3 --mode 2560x1440 --pos 0x0 --rotate normal --left-of DisplayPort-2 \
       --output DisplayPort-4 --off \
       --output DisplayPort-5 --off
fi
