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

	local layout = "";
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")

	. "$XDG_CONFIG_HOME/display_layout.sh" "$layout"
	if [ "$layout" = "solo" ]; then
		bspc monitor --reset-desktops 1 2 3 4 5 6 7 8 9 10
	elif [ "$layout" = "office" ]; then
		bspc monitor eDP --reset-desktops 1 2 3 4 5 6 7 8 9 10
		bspc monitor DisplayPort-0 --reset-desktops A B C D E F G H I J
	else
		bspc monitor --reset-desktops 1 2 3 4 5 6 7 8 9 10
	fi

	bspc config automatic_scheme alternate
	bspc config border_width 0
	bspc config focus_follows_pointer false
	bspc config pointer_follows_monitor true
	bspc config remove_unplugged_monitors true
	bspc config swallow_first_click false
	bspc config split_ratio 0.5
	bspc config window_gap 7
	bspc config active_border_color $colorfg
	bspc config focused_border_color $color03
	bspc config normal_border_color $colorfg
	bspc config presel_feedback_color $color03

	bspc rule --add "*" state=floating layer=bellow
	bspc wm --record-history on
}

wm_kill_daemons () {
	killall -q picom
	killall -q redshift
	killall -q sxhkd
	killall -q flashfocus
	killall -q dunst
	killall -q polybar
	killall -q tint2
}

wm_start_daemons () {
	. "$HOME/.bashrc"

	export BOL_ICON="$(echo -e "\uf0e7 ")"
	export CAL_ICON="$(echo -e "\uf073")"
	export CPU_ICON="$(echo -e "\uf5dc ")"
	export ETH_ICON="$(echo -e "\uf796 ")"
	export EXG_ICON="$(echo -e "\uf362 ")"
	export FRQ_ICON="$(echo -e "\uf83e ")"
	export HDD_ICON="$(echo -e "\uf0a0 ")"
	export HGL_ICON="$(echo -e "\uf252 ")"
	export KBD_ICON="$(echo -e "\uf11c ")"
	export MEM_ICON="$(echo -e "\uf538 ")"
	export MUT_ICON="$(echo -e "\uf6a9")"
	export PWR_ICON="$(echo -e "\uf011")"
	export TMP_ICON="$(echo -e "\uf2c8 ")"
	export WIF_ICON="$(echo -e "\uf1eb")"
	export BAT_ICON="$(echo -e "\uf241 ")"
	export PCO_ICON="$(echo -e "\uf1e6 ")"
	export BFL_ICON="$(echo -e "\uf240 ")"
	export BKL_ICON="$(echo -e "\uf0eb ")";
	SXHKD_SHELL=/usr/bin/bash

	set-wallpaper &

	rm -rf "$HOME/.local/share/picom/log"
	[ ! -p "$HOME/.local/share/polybar/polytimer-fifo" ] &&
		mkfifo "$HOME/.local/share/polybar/polytimer-fifo"

	local layout = "";
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")
	if [ "$layout" = "solo" ]; then
		polybar solo &> "$HOME/.local/share/polybar/solo.log" &
	elif [ "$layout" = "office" ]; then
		polybar laptop &> "$HOME/.local/share/polybar/laptop.log" &
		polybar external &> "$HOME/.local/share/polybar/external.log" &
	else
		polybar solo &> "$HOME/.local/share/polybar/solo.log" &
	fi

	dunst &> "$HOME/.local/share/dunst/log" &
	flashfocus &
	while pgrep -u $UID -x redshift > /dev/null; do sleep 1; done && redshift &
	sxhkd -m 1 &
	tint2 &> "$HOME/.local/share/tint2/log" &

	local picom_wait_usec=$((500 * 1000))
	usleep $picom_wait_usec && picom --daemon --experimental-backends &
}
