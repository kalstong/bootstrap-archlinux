#!/bin/sh

wm_config_monitors () {
	local db=$(xrdb -query)
	local colorbg=$(echo "$db" | grep '^\*\.background:' | awk '{print $2}')
	local colorfg=$(echo "$db" | grep '^\*\.foreground:' | awk '{print $2}')
	local color01=$(echo "$db" | grep '^\*\.color1:' | awk '{print $2}')
	local color02=$(echo "$db" | grep '^\*\.color2:' | awk '{print $2}')
	local color03=$(echo "$db" | grep '^\*\.color3:' | awk '{print $2}')
	local color04=$(echo "$db" | grep '^\*\.color4:' | awk '{print $2}')
	local color05=$(echo "$db" | grep '^\*\.color5:' | awk '{print $2}')
	local color06=$(echo "$db" | grep '^\*\.color6:' | awk '{print $2}')
	local color07=$(echo "$db" | grep '^\*\.color7:' | awk '{print $2}')
	local color08=$(echo "$db" | grep '^\*\.color8:' | awk '{print $2}')
	local color09=$(echo "$db" | grep '^\*\.color9:' | awk '{print $2}')
	local color10=$(echo "$db" | grep '^\*\.color10:' | awk '{print $2}')
	local color11=$(echo "$db" | grep '^\*\.color11:' | awk '{print $2}')
	local color12=$(echo "$db" | grep '^\*\.color12:' | awk '{print $2}')
	local color13=$(echo "$db" | grep '^\*\.color13:' | awk '{print $2}')
	local color14=$(echo "$db" | grep '^\*\.color14:' | awk '{print $2}')
	local color15=$(echo "$db" | grep '^\*\.color15:' | awk '{print $2}')

	local layout=""
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")

	. "$XDG_CONFIG_HOME/display_layout.sh" "$layout" &
}

wm_kill_daemons () {
	killall -q picom &
	killall -q redshift &
	killall -q flashfocus &
	killall -q dunst &
	killall -q -9 polybar &
	killall -q tint2 &
}

wm_start_daemons () {

    local hour=$(date '+%H')
    local tod=""
    if [ $hour -ge 6 ] && [ $hour -lt 14 ]; then
    	tod="morning"
    elif [ $hour -ge 14 ] && [ $hour -lt 20 ]; then
   		tod="afternoon"
   	else
   		tod="night"
   	fi

	local img=$(ls "$WALLPAPERS/$tod" | shuf -n 1)
    feh --bg-fill "$WALLPAPERS/$tod/$img" &
    echo "$WALLPAPERS/$tod/$img" > /tmp/wallpaper &

	rm -rf "$HOME/.local/share/picom/log" &
	[ ! -p "$HOME/.local/share/polybar/polytimer-fifo" ] &&
		mkfifo "$HOME/.local/share/polybar/polytimer-fifo" &

	local layout=""
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")
	if [ -z "$layout" ] || [ "$layout" = "single" ]; then
		polybar single &> "$HOME/.local/share/polybar/single.log" &
	elif [ "$layout" = "office" ]; then
		polybar laptop &> "$HOME/.local/share/polybar/laptop.log" &
		polybar external &> "$HOME/.local/share/polybar/external.log" &
	elif [ "$layout" = "home" ]; then
		polybar laptop &> "$HOME/.local/share/polybar/laptop.log" &
		polybar external &> "$HOME/.local/share/polybar/external.log" &
	fi

	dunst &> "$HOME/.local/share/dunst/log" &
	flashfocus &
	while pgrep -u $UID -x redshift > /dev/null; do sleep 1; done && redshift &
	tint2 &> "$HOME/.local/share/tint2/log" &

	local picom_wait_usec=$((500 * 1000))
	usleep $picom_wait_usec && picom --daemon --experimental-backends &
}

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)" &

wm_config_monitors && wm_start_daemons &
