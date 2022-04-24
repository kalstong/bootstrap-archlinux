#!/bin/sh

if [ "$1" = "solo" ]; then
xrandr --output eDP --primary --mode 2560x1440 --pos 0x0 --rotate normal \
       --output DisplayPort-0 --off \
       --output DisplayPort-1 --off \
       --output DisplayPort-2 --off

fi
