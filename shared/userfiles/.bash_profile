. "$HOME/.bashrc"

if shopt -q login_shell; then
	[ -f "$XDG_CONFIG_HOME/.brightnessctl" ] &&
		brightnessctl set $(cat "$XDG_CONFIG_HOME/.brightnessctl") > /dev/null

	export agent_status=$(ps -U $USER | grep 'ssh-agent')

	if [ -f "$XDG_CONFIG_HOME/.energypolicy" ]; then
		energypolicy $(tail -n 1 "$XDG_CONFIG_HOME/.energypolicy")
	fi

	if [ -z "$agent_status" ]; then
		export agent_config=$(ssh-agent)
		export SSH_AUTH_SOCK=$(echo $agent_config | grep -Po "SSH_AUTH_SOCK=\K\S+(?=;)")
	fi

	# Remove mount points left from the previous session
	for dir in $(ls "$MOUNT"); do
		[ -d "$MOUNT/$dir" ] && {
			mountpoint "$MOUNT/$dir" &> /dev/null ||
			rm -rf "$MOUNT/$dir"
		}
	done

	if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ] &&
	   [ "$TERM" != "screen" ] && [ $(command -v startx) ]; then
		exec startx -- -keeptty -ardelay 190 -arinterval 15 &> ~/.local/share/xorg/tty.log
	elif [ "$TERM" = "linux" ]; then
		sudo kbdrate -s -d 190 -r 100
		clear
	fi
fi

# vim:ft=sh
