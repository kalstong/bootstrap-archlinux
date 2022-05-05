#!/bin/sh

if [ "$1" = "solo" ]; then
xrandr --output eDP --primary --mode 1920x1080 --pos 0x1440 --rotate normal \
       --output DisplayPort-0 --off \
       --output DisplayPort-1 --off \
       --output DisplayPort-2 --off

elif [ "$1" = "dual" ]; then
xrandr --output eDP --primary --mode 1920x1080 --pos 2560x0 --rotate normal \
       --output DisplayPort-0 --mode 2560x1440 --pos 0x0 --rotate normal \
       --output DisplayPort-1 --off \
       --output DisplayPort-2 --off
fi


#!/bin/sh
