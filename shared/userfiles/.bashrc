PS1="\[$(tput setaf 5)\]\A\[$(tput sgr0)\] \w$([ -n "$NNNLVL" ] && echo " nnn:$NNNLVL") \[$(tput setaf 6)\]>\[$(tput sgr0)\] "

. "$HOME/.bashrc.aux"

[ -f "${DVM_ROOT}/scripts/dvm" ] &&
	. "${DVM_ROOT}/scripts/dvm"

export FORGIT_NO_ALIASES="true"
export FORGIT_FZF_DEFAULT_OPTS="--cycle --reverse --height '80%'"
. "$HOME/.forgit.plugin.sh"

NVM_SYMLINK_CURRENT="true"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "$NVM_DIR/nvm.sh" ] &&
	[[ "$PATH" != *"$NVM_DIR/current/bin"* ]] &&
	[ -d "$NVM_DIR/current/bin" ] &&
	PATH="$NVM_DIR/current/bin:$PATH"

set_vte_theme () {
	if [ "$TERM" = "linux" ]; then
		[ -f "$HOME/.cache/wal/colors-tty.sh" ] &&
			. "$HOME/.cache/wal/colors-tty.sh"
		[ -n "$VTFONT" ] && setfont "$VTFONT"
	fi
}
set_vte_theme

# Based on https://github.com/mrzool/bash-sensible
# ------------------------------------------------
if [[ $- == *i* ]]; then
	shopt -s checkwinsize
	PROMPT_DIRTRIM=3
	bind Space:magic-space
	shopt -s globstar 2> /dev/null
	shopt -s nocaseglob
	bind "set blink-matching-paren on"
	bind "set colored-completion-prefix on"
	bind "set colored-stats on"
	bind "set completion-ignore-case on"
	bind "set completion-map-case on"
	bind "set editing-mode vi"
	bind "set mark-symlinked-directories on"
	bind "set show-all-if-ambiguous on"
	bind "set show-mode-in-prompt on"
	bind "set visible-stats on"
	bind "set vi-cmd-mode-string $(tput setaf 4)cmd $(tput sgr0)"
	bind "set vi-ins-mode-string"
	shopt -s histappend
	shopt -s cmdhist
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
	bind '"\C-l": clear-display'
	bind '"\C-n": history-search-forward'
	bind '"\C-p": history-search-backward'
	bind '"\e[C": forward-char'
	bind '"\e[D": backward-char'
	shopt -s autocd 2> /dev/null
	shopt -s direxpand 2> /dev/null
	shopt -s dirspell 2> /dev/null
	shopt -s cdspell 2> /dev/null
	CDPATH="."
	shopt -s cdable_vars
fi

export BAT_THEME=zenburn
export CLICOLOR=1
export HISTSIZE=32768
export HISTFILESIZE=32768
export HISTCONTROL=ignoreboth:ereasedups
export HISTIGNORE="?:??:???:????:?????"
export HISTTIMEFORMAT="%F %T "
export LESSCHARSET=UTF-8

alias aria2c="aria2c --async-dns=false"
alias beep="tput bel"
alias less="bat"
alias l="exa -1"
alias la="exa -1a"
alias lar="exa -1aR"
alias lh="exa -1ad .??*"
alias ll="exa -lh"
alias lla="exa -ahl"
alias llar="exa -ahlR"
alias llh="exa -adhl .??*"
alias llr="exa -lhR"
alias lr="exa -1R"
alias ls="exa"
alias lsa="exa -ah"
alias n="nvim"
alias nn="nvim -n -u NONE -i NONE"
alias q="exit"

c () {
	clear
}

clipit () {
	if [ -f "$1" ]; then
		local mimetype="$(file --brief --mime-type "$1")"
		[ "$mimetype" = "text/plain" ] && xclip -selection clipboard -in "$1"
		[ "$mimetype" != "text/plain" ] && xclip -selection clipboard -target "$mimetype" -in "$1"
	fi
}

display_layout () {
	[ -z $1 ] && return

	local layout=""
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	local layout_new="$1"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")

	[ "$layout" != "$layout_new" ] &&
		echo "$layout_new" > "$layout_file" &&
		bspc wm --restart
}

energypolicy () {
	if [ "$1" = "default" ]; then
		. "$XDG_CONFIG_HOME/.energypolicy.sh" default
	elif [ "$1" = "performance" ]; then
		. "$XDG_CONFIG_HOME/.energypolicy.sh" performance
	elif [ "$1" = "balanced" ]; then
		. "$XDG_CONFIG_HOME/.energypolicy.sh" balanced
	elif [ "$1" = "powersave" ]; then
		. "$XDG_CONFIG_HOME/.energypolicy.sh" powersave
	elif [ "$1" = "ultrapowersave" ]; then
		. "$XDG_CONFIG_HOME/.energypolicy.sh" ultrapowersave
	elif [ -n "$1" ]; then
			echo "Invalid profile $1. Usage: energypolicy [default|performance|balanced|powersave|ultrapowersave]."
			return
	else
		[ -f "$XDG_CONFIG_HOME/.energypolicy" ] && \
			echo "Current profile is" $(tail -n 1 "$XDG_CONFIG_HOME/.energypolicy") || \
			echo "No profile is currently set. Usage: energypolicy [default|performance|balanced|powersave]"
		return
	fi
}

has-cmd () {
	command -v "$1" &> /dev/null
}

logout () {
	. "$HOME/.config/polybar/terminate-session.sh"
}

makefs () {
	local fs=$1
	local part=$(echo "$2" | sed -e 's/^[[:space:]]*//')
	local label=$3
	[ -z "$fs" ] &&
		echo "Missing fs type: exfat, fat32, f2fs, luks or ntfs." &&
		return 1
	[ -z "$part" ] &&
		echo "Missing target partition." &&
		return 1

	local fslist="exfat fat32 f2fs luks ntfs"
	[[ " $fslist " =~ .*\ $fs\ .* ]]

	local _part=$(
		lsblk --list --output PATH,SIZE,FSTYPE,TYPE,MOUNTPOINT |
		grep "${part}.*part[[:space:]]*$\|crypt[[:space:]]*$" |
		awk '{printf "%s",$1}')
	[ -z "$_part" ] &&
		echo "Target partiton is not available or is mounted: '$part'." &&
		return 1

	[ "$fs" = "exfat" ] &&
		sudo mkfs.exfat --verbose --volume-label="$label" "$part"
	[ "$fs" = "fat32" ] &&
		sudo mkfs.fat -c -F 32 -n "$label" -v "$part"
	[ "$fs" = "f2fs" ] &&
		sudo mkfs.f2fs -O extra_attr,inode_checksum,sb_checksum,compression,encrypt \
			-l "$label" "$part"
	[ "$fs" = "luks" ] &&
		sudo cryptsetup --verbose --verify-passphrase luksFormat "$part" \
			--type luks2 --sector-size 4096
	[ "$fs" = "ntfs" ] &&
		sudo mkfs.ntfs --fast --label "$label" --enable-compression "$part"
}

mkcd () {
	mkdir -p "$1"
	cd "$1"
}

mnt () {
	# TODO: How to detect if a LUKS device is opened:
	# https://unix.stackexchange.com/a/302850

	# 1. List all partitons
	# 2. Grep the ones that aren't mounted
	# 3. Send them to `fzf'
	# 4. Grab de selectd partition
	local part=$(lsblk --list --output PATH,SIZE,FSTYPE,TYPE,MOUNTPOINT |
		grep 'part[[:space:]]*$\|crypt[[:space:]]*$' | grep --invert-match 'crypto_LUKS' |
		awk '{printf "%s %s %s\n",$1,$2,$3}' |
		fzf --reverse | awk '{printf "%s %s %s",$1,$2,$3}')
	[ -z "$part" ] && return

	# Find the directories at $MOUNT that aren't already used as a mount point.
	# Taken from: https://catonmat.net/set-operations-in-unix-shell
	# local mountpoint=$(comm -23 <(/bin/ls -1Ld $MOUNT/* | sort) \
	# 	<(mount | awk '{print $3}' | sort) | fzf)
	# [ -z $mountpoint ] && return

	local mountpoint="${MOUNT}/mnt$(($(/usr/bin/ls -1 $MOUNT | grep '^mnt*' | wc -l) + 1))"
	mkdir -p "$mountpoint" || { echo "Failed to directory for mount point: '$mountpoint'" && return 1; }

	local path=$(echo "$part" | awk '{print $1}')
	local fstype=$(echo "$part" | awk '{print $3}')
	if [ "$fstype" = "exfat" ]; then
		sudo mount -t exfat --options-mode ignore \
			-o gid=users,fmask=113,dmask=002,discard,lazytime,relatime \
			"$path" "$mountpoint" 2> /dev/null

	elif [ "$fstype" = "ext4" ]; then
		sudo mount -t ext4 --options-mode ignore -o defaults,discard,lazytime \
			"$path" "$mountpoint" 2> /dev/null &&
		sudo chown $USER:users "$mountpoint"

	elif [ "$fstype" = "f2fs" ]; then
		sudo mount -t f2fs --options-mode ignore -o atgc,discard,gc_merge,lazytime,relatime,whint_mode=fs-based \
			"$path" "$mountpoint" 2> /dev/null &&
		sudo chown $USER:users "$mountpoint"

	elif [ "$fstype" = "iso9660" ]; then
		sudo mount -t iso9660 --options-mode ignore -o ro \
			"$path" "$mountpoint" 2> /dev/null

	elif [ "$fstype" = "ntfs" ]; then
		sudo mount -t ntfs3 --options-mode ignore -o discard,lazytime,relatime \
			"$path" "$mountpoint" 2> /dev/null &&
		sudo chown $USER:users "$mountpoint"

	elif [ "$fstype" = "vfat" ]; then
		sudo mount -t vfat --options-mode ignore \
			-o gid=users,fmask=113,dmask=002,discard,flush,lazytime,relatime \
			"$path" "$mountpoint" 2> /dev/null

	else
		sudo mount --options-mode ignore \
			-o gid=users,fmask=113,dmask=002,discard,flush,lazytime,relatime,sync \
			"$path" "$mountpoint" 2> /dev/null

	fi
	local res=$?

	if [ $res -eq 0 ]; then
		echo "Disk mounted at '$mountpoint'."
		[ "$1" = "--cd" ] && cd "$mountpoint" && echo "$mountpoint" | xclip -selection clipboard -in
	else
		rmdir "$mountpoint" && echo "Failed to mount '$path'."
	fi
}

mnt-gocrypt () {
	[ ! -d "$1"	] && echo "Usage: mnt-gocrypt <cypherdir>" && return 1

	local mountpoint="${MOUNT}/gocrypt$(($(/usr/bin/ls -1 $MOUNT | grep '^gocrypt*' | wc -l) + 1))"
	mkdir -p "$mountpoint" || { echo "Failed to create directory for mount point: '$mountpoint'" && return 1; }

	# gocryptfs -allow_other "$1" "$mountpoint" && echo "Disk mounted at $mountpoint" ||
	gocryptfs "$1" "$mountpoint"
	local res=$?

	if [ $res -eq 0 ]; then
		echo "Gocrypt disk mounted at '$mountpoint'."
		[ "$2" = "--cd" ] && cd "$mountpoint" && echo "$mountpoint" | xclip -selection clipboard -in
	else
		rmdir "$mountpoint" && echo "Failed to mount '$1'."
	fi
}

mnt-ssh () {
	[ -z "$1" ] && echo "Usage: mnt-ssh <user>@<host>:<dir> [port]" && return 1

	local mountpoint="${MOUNT}/sshfs$(($(/usr/bin/ls -1 $MOUNT | grep '^sshfs*' | wc -l) + 1))"
	mkdir -p "$mountpoint" || { echo "Failed to create directory for mount point: '$mountpoint'" && return 1; }

	local port="${2:-22}"
	sshfs "$1" "$mountpoint" -C -p $port
	local res=$?

	if [ $res -eq 0 ]; then
		echo "SSHFS disk mounted at '$mountpoint'."
		[ "$2" = "--cd" ] && cd "$mountpoint" && echo "$mountpoint" | xclip -selection clipboard -in
	else
		rmdir "$mountpoint" && echo "Failed to mount '$1'."
	fi
}

mnt-vcrypt () {
	[ ! -f "$1" ] && echo "Usage: mnt-vcrypt <veracrypt-file>" && return 1

	local mountpoint="${MOUNT}/vcrypt$(($(/usr/bin/ls -1 $MOUNT | grep '^vcrypt*' | wc -l) + 1))"
	mkdir -p "$mountpoint" || { echo "Failed to create directory for mount point: '$mountpoint'" && return 1; }

	veracrypt --text --keyfiles="" --pim=0 --protect-hidden=no "$1" "$mountpoint"
	local res=$?

	if [ $res -eq 0 ]; then
		echo "Veracrypt disk mounted at '$mountpoint'."
		[ "$2" = "--cd" ] && cd "$mountpoint" && echo "$mountpoint" | xclip -selection clipboard -in
	else
		rmdir "$mountpoint" && echo "Failed to mount '$1'."
	fi
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
	local bottom_gap=60
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

notes () {
	[ -n "$1" ] && nvim "$NOTES/$(sanitize $1).txt"
	[ -z "$1" ] && e "$NOTES"
}

purge () {
	if [ "$1" == "bash" ]; then
		history -c
		rm -f "$HOME/.bash_history"

	elif [ "$1" == "cache" ]; then
		sync
		echo 1 | sudo tee /proc/sys/vm/drop_caches &> /dev/null
		echo "System cache was cleared."

	elif [ "$1" == "clipboard" ]; then
		xclip -selection clipboard -in /dev/null
		xclip -selection primary -in /dev/null
		xclip -selection secondary -in /dev/null

	elif [ "$1" == "nvim" ]; then
		rm -f ~/.local/share/nvim/shada/*.shada

	else echo "Unknown or empty argument '$1'."
	fi
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

qemu-create () {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		echo "qemu-create <volume-name> <volume-size><G|M|K>"
		echo "example: qemu-create vm1 16G"
		return 0;
	fi

	[ -z "$1" ] && echo "ERROR: missing volume name." && return 1
	[ -z "$2" ] && echo "ERROR: missing volume size." && return 1

	qemu-img create -f qcow2 "$1".img.qcow2 "$2"
}

qemu-snapshot () {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		echo "qemu-snapshot <source-volume> <snapshot-volume-name>"
		echo "example: qemu-snapshot vm1 vm1-snapshot"
		return 0;
	fi

	[ ! -f "$1" ] && echo "ERROR: missing or invalid source volume." && return 1
	[ ! -z "$2" ] && echo "ERROR: missing snapshot volume name." && return 1

	qemu-img create -f qcow2 -b "$(pwd)/$2" "$(pwd)/$3";
}

qemu-start () {

	local cdroms=()
	local volumes=()

	local num_cpu_cores=""
	local ram_size=""

	local ssh_port=""
	local enable_igvt=false

	local firmware_type="bios"
	local guest_type="linux"

	while [[ $# -gt 0 ]]
	do
		case "$1" in
			-h|--help)
				echo "qemu-start -n|--num-cpu-cores <n> -r|--ram-size <n><K|G|T> -s|--ssh-port <n>"
				echo "[-c|--cdrom <cdrom-file>]"
				echo "[-f|--firmware-type bios|uefi (default $firmware_type)]"
				echo "[-g|--guest-type linux|windows (default $guest_type)]"
				echo "[-v|--volume <volume-file>]"
				echo "[--enable-igvt]"
				return 0
				;;
			-c|--cdrom)
				cdroms=(${cdroms[@]} "$2")
				shift
				shift
				;;
			-f|--firmware-type)
				firmware_type="$2"
				shift
				shift
				;;
			-g|--guest-type)
				guest_type="$2"
				shift
				shift
				;;
			-n|--num-cpu-cores)
				num_cpu_cores="$2"
				shift
				shift
				;;
			-r|--ram-size)
				ram_size="$2"
				shift
				shift
				;;
			-s|--ssh-port)
				ssh_port="$2"
				shift
				shift
				;;
			-v|--volume)
				volumes=(${volumes[@]} "$2")
				shift
				shift
				;;
			--enable-igvt)
				enable_igvt=true
				shift
				;;
			*)
				echo "Unknown option: '$1'. Will be ignored."
				shift
				;;
		esac
	done

	$($enable_igvt) &&
	echo "Creating iGVT device..." &&
	local igvt_dev_uuid="$(uuidgen)" &&
	echo "$igvt_dev_uuid" | sudo tee -a "/sys/devices/pci0000:00/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create" > /dev/null &&
	local qemu_igvt_device="-device vfio-pci,sysfsdev=/sys/bus/mdev/devices/$igvt_dev_uuid,display=on,x-igd-opregion=on,ramfb=on,driver=vfio-pci-nohotplug"

	$([ $($enable_igvt) ] && echo "sudo ") \
	qemu-system-x86_64 -enable-kvm -machine q35 -m "$ram_size" \
		$([ "$guest_type" = "linux" ] && echo "-cpu max" ) \
		$([ "$guest_type" = "windows" ] && echo "-cpu max,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time") \
		$([ "$firmware_type" = "uefi" ] && echo "-drive file="/usr/share/edk2-ovmf/x64/OVMF_CODE.fd",if=pflash,format=raw,readonly=on") \
		$([ "$firmware_type" = "uefi" ] && echo "-drive file="/usr/share/edk2-ovmf/x64/OVMF_VARS.fd",if=pflash,format=raw,readonly=on") \
		-smp "cores=$num_cpu_cores" \
		-device intel-iommu,caching-mode=on \
		-device virtio-balloon \
		$([ $($enable_igvt) ] && echo "$qemu_igvt_device") \
		-object rng-random,filename=/dev/random,id=rng0 -device virtio-rng-pci,id=rng0 \
		$([ $($enable_igvt) ] && echo "-vga none -display gtk,gl=on") \
		$([ ! $($enable_igvt) ] && echo "-vga virtio -display gtk,gl=on") \
		-usb -device usb-tablet \
		-boot order=dc,menu=on \
		$(for v in ${volumes[@]}; do echo "-drive file=$v,format=qcow2,if=virtio,aio=native,cache.direct=on"; done) \
		$(for i in ${!cdroms[@]}; do echo "-drive file=${cdroms[$i]},index=$(($i + 2)),media=cdrom,readonly=on"; done) \
		-nic user,model=virtio-net-pci,hostfwd=tcp::"$ssh_port"-:22,smb=$(pwd)

	$($enable_igvt) &&
		echo "Destroying iGVT device..." &&
		echo 1 | sudo tee -a "/sys/bus/pci/devices/0000:00:02.0/${igvt_dev_uuid}/remove" > /dev/null
}

random-wallpaper () {
	if [ -n "$DISPLAY" ]; then
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
		feh --bg-fill "$WALLPAPERS/$tod/$img"
		echo "$WALLPAPERS/$tod/$img" > /tmp/wallpaper
	else
		echo "You're not running a graphical session."
	fi
}

rsync-to () {
	rsync -auvP --delete $3 -e "ssh -i ~/.ssh/id_ed25519 -p 16012" "$1/" "$2"
}

# Taken from https://stackoverflow.com/a/44811468
sanitize() {
	local s="${1?need a string}"
	s="${s//[^[:alnum:]]/-}"
	s="${s//+(-)/-}"
	s="${s/#-}"
	s="${s/%-}"
	echo "${s,,}"
}

screenshot () {
	if [ -n "$DISPLAY" ]; then
		local filename=$(echo $(date '+%Y.%m.%d-%H.%M.%S'))

		local path="$SCREENSHOTS/${filename}.png"
		maim --hidecursor --nokeyboard --quality 10 --select "$path" &&
		clipit "$path"

		[ -f "$path" ] &&
		echo Image written to "$path" &&
		notify-send 'Screenshot' "File available at '$path'"
	fi
}

secrm () {
	if [ $# -gt 0 ]; then
		shred --force --iterations=1 --random-source=/dev/urandom -u --zero $*
	else
		echo "Usage: secrm <files...>"
	fi
}

select-wallpaper () {
	if [ -n "$DISPLAY" ]; then
		[ -f "$1" ] && feh --bg-fill "$1" &&
			echo "$1" > /tmp/wallpaper && return

		local wallpaper=""
		local hour=$(date '+%H')

		if [ $hour -ge 6 ] && [ $hour -lt 14 ]; then
			wallpaper=$(sxiv -o "$WALLPAPERS/morning")
			[ -n "$wallpaper" ] &&
				feh --bg-fill "$wallpaper" &&
				echo "$wallpaper" > /tmp/wallpaper
		elif [ $hour -ge 14 ] && [ $hour -lt 20 ]; then
			wallpaper=$(sxiv -o "$WALLPAPERS/afternoon")
			[ -n "$wallpaper" ] &&
				feh --bg-fill "$wallpaper" &&
				echo "$wallpaper" > /tmp/wallpaper
		else
			wallpaper=$(sxiv -o "$WALLPAPERS/night")
			[ -n "$wallpaper" ] &&
				feh --bg-fill "$wallpaper" &&
				echo "$wallpaper" > /tmp/wallpaper
		fi
	else
		echo "You're not running a graphical session."
	fi
}

set-wallpaper () {
[ -f /tmp/wallpaper ] && feh --bg-fill "$(cat /tmp/wallpaper)" && return
	random-wallpaper
}

shup () {
	[ ! -f "$1" ] && echo "Usage: shup <cmdfile>" && return 0

	local profile="$1"
	local cmd=""

	while read -r line; do
		line="${line##*( )}"
		[ -n "$line" ] && [ ${line:0:1} != "#" ] && cmd="${cmd} ${line}"
	done < "$profile"

	eval $cmd
}

theme () {
	local light_themes="$HOME/.local/lib/python3.10/site-packages/pywal/colorschemes/light"
	local dark_themes="$HOME/.local/lib/python3.10/site-packages/pywal/colorschemes/dark"
	local light_themes dark_themes
	light_themes="$(ls -1 $light_themes | sed "s/.json//" | awk '{print "light - " $0}')"
	dark_themes="$(ls -1 $dark_themes | sed "s/.json//" | awk '{print "dark - " $0}')"

	local selection category name
	selection="$(echo -e  "$dark_themes" "\n$light_themes" | fzf)"
	if [ -n "$selection" ]; then
		category="$(echo "$selection" | grep -o '^\S*')"
		name="$(echo "$selection" | grep -o '\S*$')"
		[ "$category" == "dark" ] && wal --theme "$name"
		[ "$category" == "light" ] && wal --theme "$name" -l
		has-cmd xrdb && xrdb -merge "$HOME/.Xresources"
		has-cmd xrdb && xrdb -merge "$HOME/.cache/wal/colors.Xresources"
		. "$HOME/.local/bin/alacritty-theme.sh" &> /dev/null
	fi
}

umnt () {
	# Find the directories at $MOUNT that are already used as a mount point.
	# Taken from: https://catonmat.net/set-operations-in-unix-shell
	# local mountpoint=$(comm -12 <(/bin/ls -1Ld $MOUNT/* | sort) \
	# 	<(mount | awk '{print $3}' | sort) | fzf)
	# [ -z $mountpoint ] && return

  for dir in $(/bin/ls -1Ld $MOUNT/* 2> /dev/null); do
		local source="$(findmnt --first-only --noheadings --output SOURCE $dir)"
		if [ "$source" ]; then
			local mounts="${mounts}\n$(findmnt --first-only --noheadings --output SOURCE $dir |
				awk -v dir="$dir" '{print dir " -> " $1}')"
		fi
	done

	[ "$mounts" ] &&
	local mountpoint=$(printf "$mounts" | tail -n +2 | fzf --reverse | awk '{print $1}') ||
	{ echo "No mounted volumes at $MOUNT/" && return 1; }

	if [[ "$mountpoint" =~ sshfs ]]; then
		fusermount3 -u "$mountpoint" &&
			echo "Unmounted '$mountpoint'." &&
			rmdir "$mountpoint"
	elif [[ "$mountpoint" =~ vcrypt ]]; then
		veracrypt --text --dismount "$mountpoint" &&
			echo "Unmounted '$mountpoint'." &&
			rmdir "$mountpoint"
	elif [ "$mountpoint" ]; then
		sudo umount "$mountpoint" &&
			echo "Unmounted '$mountpoint'." &&
			rmdir "$mountpoint"
	fi
}

vcrypt-create () {
	[ -z "S1" ] || [ -z "$2" ] && \
		echo "Usage: vcrypt-create <path-to-encrypted-file> <size><K|M|G>" && \
		return 1;

	veracrypt --text --create "$1" --volume-type="normal" --size="$2" \
		--filesystem="exFAT" --encryption="AES" --hash="SHA-512" --pim=0 \
		--keyfiles="" --random-source="/dev/urandom"
}

export FZF_DEFAULT_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --exclude '.git/' --hidden --type d"
[[ $- == *i* ]] && . "/usr/share/fzf/completion.bash" 2> /dev/null
[ -f "/usr/share/fzf/key-bindings.bash" ] && . "/usr/share/fzf/key-bindings.bash"

export GPG_TTY=$(tty)
encgpg () { gpg -c -o "$1" "$2"; }
decgpg () { gpg -d "$1" | nvim -i NONE -n -; }

export NNN_PLUG='a:archive;d:fzcd;e:_nvim $nnn*;f:-fzopen;k:-pskill'
e () {
	nnn -x "$@"
	export NNN_TMPFILE="$XDG_CONFIG_HOME/nnn/.lastd"

	if [ -f "$NNN_TMPFILE" ]; then
		. "$NNN_TMPFILE"
		rm -f "$NNN_TMPFILE" &> /dev/null
	fi

	[ "$TERM" = "linux" ] && set_vte_theme && clear
}
