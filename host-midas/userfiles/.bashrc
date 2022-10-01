export EDITOR="nvim"
export HOST="3700u"
export MOUNT="/mnt/media"
export AUR="$HOME/aur"
export CACHE="$HOME/.cache"
export CODE="$HOME/code"
export DOWNLOADS="$HOME/files/downloads"
export FILES="$HOME/files"
export TRASH="$HOME/trash"
export WORK="$HOME/work"

export ASDF_DATA_DIR="$CACHE/asdf"
export GOBIN="$HOME/.local/bin/go"
export GOCACHE="$CACHE/go/build"
export GOMODCACHE="$CACHE/go/lib/pkg/mod"
export GOPATH="$CACHE/go/lib"
export GOROOT="$CACHE/go/bin"
export LF_BOOKMARKS_PATH="$XDG_CONFIG_HOME/lf/bookmarks"
export NOTES="$FILES/notes"
export NPM_CONFIG_CACHE="$CACHE/npm"
export RECORDINGS="$FILES/recordings"
export SCREENSHOTS="$FILES/screenshots"
export WALLPAPERS="$FILES/wallpapers"
export YARN_CACHE_FOLDER="$CACHE/yarn"

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"
[[ ! "$PATH" =~ "$GOPATH/bin" ]] && export PATH="$PATH:$GOPATH/bin"
[[ ! "$PATH" =~ "$JAI_DIR" ]] && export PATH="$PATH:${JAI_DIR}/bin"

display-layout () {
	[ -z $1 ] && return

	local layout=""
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	local layout_new="$1"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")

	[ "$layout" != "$layout_new" ] &&
		echo "$layout_new" > "$layout_file" &&
		bspc wm --restart
}

move-window () {
	# Stop right now if the window is not floating
	[ -z $(bspc query -N --node focused.floating) ] && return 1

	local focused_screen_name=$(bspc query -M --monitor focused --names)
	local xrandr_screen_info=$(xrandr --listactivemonitors | grep "$focused_screen_name")
	local screen_width=$(echo "$xrandr_screen_info" | sed -n -e 's/.* \([[:digit:]]\+\)\/[[:digit:]]\+x\([[:digit:]]\+\).*/\1/p')
	local screen_height=$(echo "$xrandr_screen_info" | sed -n -e 's/.* \([[:digit:]]\+\)\/[[:digit:]]\+x\([[:digit:]]\+\).*/\2/p')
	local screen_offset_x=$(echo "$xrandr_screen_info" | sed -n -e 's/.*\([+|-][[:digit:]]\+\)\([+|-][[:digit:]]\+\).*/\1/p')
	local screen_offset_y=$(echo "$xrandr_screen_info" | sed -n -e 's/.*\([+|-][[:digit:]]\+\)\([+|-][[:digit:]]\+\).*/\2/p')
	local top_gap=60
	local bottom_gap=55
	local left_gap=20
	local right_gap=20

	eval "$(xdotool getactivewindow getwindowgeometry --shell)"
	local win_width=$WIDTH
	local win_height=$HEIGHT


	while [ "$#" -gt 0 ]; do
		case $1 in
			top-left)
				local xpos=$((screen_offset_x + left_gap))
				local ypos=$((screen_offset_y + top_gap))
				shift
				;;
			top-center)
				local xpos=$((screen_offset_x + screen_width / 2 - win_width / 2))
				local ypos=$((screen_offset_y + top_gap))
				shift
				;;
			top-right)
				local xpos=$((screen_offset_x + screen_width - win_width - right_gap))
				local ypos=$((screen_offset_y + top_gap))
				shift
				;;

			center-left)
				local xpos=$((screen_offset_x + left_gap))
				local ypos=$((screen_offset_y + screen_height / 2 - win_height / 2))
				shift
				;;
			center)
				local xpos=$((screen_offset_x + screen_width / 2 - win_width / 2))
				local ypos=$((screen_offset_y + screen_height / 2 - win_height / 2))
				shift
				;;
			center-right)
				local xpos=$((screen_offset_x + screen_width - win_width - right_gap))
				local ypos=$((screen_offset_y + screen_height / 2 - win_height / 2))
				shift
				;;

			bottom-left)
				local xpos=$((screen_offset_x + left_gap))
				local ypos=$((screen_offset_y + screen_height - win_height - bottom_gap))
				shift
				;;
			bottom-center)
				local xpos=$((screen_offset_x + screen_width / 2 - win_width / 2))
				local ypos=$((screen_offset_y + screen_height - win_height - bottom_gap))
				shift
				;;
			bottom-right)
				local xpos=$((screen_offset_x + screen_width - win_width - right_gap))
				local ypos=$((screen_offset_y + screen_height - win_height - bottom_gap))
				shift
				;;

			*)
				return 1
				;;
		esac
	done

	[ -n "$xpos" ] && [ -n "$ypos" ] && xdotool getactivewindow windowmove -- $xpos $ypos
}
resize-window () {
	# Stop right now if the window is not floating
	[ -z $(bspc query -N --node focused.floating) ] && return 1

	local window_geometry=$(xdotool getwindowgeometry $(bspc query -N --node focused.floating))
	local focused_screen_name=$(bspc query -M --monitor focused --names)
	local xrandr_screen_info=$(xrandr --listactivemonitors | grep "$focused_screen_name")
	local screen_width=$(echo "$xrandr_screen_info" | sed -n -e 's/.* \([[:digit:]]\+\)\/[[:digit:]]\+x\([[:digit:]]\+\).*/\1/p')
	local screen_height=$(echo "$xrandr_screen_info" | sed -n -e 's/.* \([[:digit:]]\+\)\/[[:digit:]]\+x\([[:digit:]]\+\).*/\2/p')
	local screen_offset_x=$(echo "$xrandr_screen_info" | sed -n -e 's/.*\([+|-][[:digit:]]\+\)\([+|-][[:digit:]]\+\).*/\1/p')
	local screen_offset_y=$(echo "$xrandr_screen_info" | sed -n -e 's/.*\([+|-][[:digit:]]\+\)\([+|-][[:digit:]]\+\).*/\2/p')
	local top_gap=70
	local bottom_gap=60
	local left_gap=20
	local right_gap=20

	eval "$(xdotool getactivewindow getwindowgeometry --shell)"
	local win_width=$WIDTH
	local win_height=$HEIGHT
	local win_x=$X
	local win_y=$Y


	while [ "$#" -gt 0 ]; do
		case $1 in
			top-left)
				local xpos=$((screen_offset_x + left_gap))
				local ypos=$((screen_offset_y + top_gap))
				shift
				;;
			top-center)
				local xpos=$((screen_offset_x + screen_width / 2 - win_width / 2))
				local ypos=$((screen_offset_y + top_gap))
				shift
			;;
			top-right)
				local xpos=$((screen_offset_x + screen_width - win_width - right_gap))
				local ypos=$((screen_offset_y + top_gap))
				shift
				;;

			center-left)
				local xpos=$((screen_offset_x + left_gap))
				local ypos=$((screen_offset_y + screen_height / 2 - win_height / 2))
				shift
				;;
			center)
				local xpos=$((screen_offset_x + screen_width / 2 - win_width / 2))
				local ypos=$((screen_offset_y + screen_height / 2 - win_height / 2))
				shift
				;;
			center-right)
				local xpos=$((screen_offset_x + screen_width - win_width - right_gap))
				local ypos=$((screen_offset_y + screen_height / 2 - win_height / 2))
				shift
				;;

			bottom-left)
				local xpos=$((screen_offset_x + left_gap))
				local ypos=$((screen_offset_y + screen_height - win_height - bottom_gap))
				shift
				;;
			bottom-center)
				local xpos=$((screen_offset_x + screen_width / 2 - win_width / 2))
				local ypos=$((screen_offset_y + screen_height - win_height - bottom_gap))
				shift
				;;
			bottom-right)
				local xpos=$((screen_offset_x + screen_width - win_width - right_gap))
				local ypos=$((screen_offset_y + screen_height - win_height - bottom_gap))
				shift
				;;

			*)
				return 1
				;;
		esac
	done

	[ -n "$xpos" ] && [ -n "$ypos" ] && xdotool getactivewindow windowmove -- $xpos $ypos
}