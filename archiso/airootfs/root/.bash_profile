if shopt -q login_shell; then
	systemctl start --no-block dhcpcd iwd pacman-init
	locale-gen

	# Only for reference. These are already set in /etc/vconsole.conf
	# loadkeys pt-latin1
	# setfont ter-118n

	kbdrate -s -d 190 -r 100 &> /dev/null
	tmux
fi
