#!/usr/bin/bash
this_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

yesno () {
	local answer
	while true; do
		read -p "$* [Y/n]: " answer
		case $answer in
			Y) true && return;;
			n) false || return;;
		esac
	done
}

out_dir="${this_script_dir}/out"
iso_file="$(/usr/bin/ls -1L $out_dir | tail -1)"

[ -z "$iso_file" ] && echo "No ISO file available." && exit 1
[ -f "$out_dir/$iso_file" ] || { echo "No ISO file found: $out_dir/$iso_file" && exit 1; }
[ -z "$1" ] && echo "Destination block device not set." && exit 1
[ -b "$1" ] || { echo "Invalid block device: $1" && exit 1; }

cmd="sudo dd if="$out_dir/$iso_file" of="$1" bs=512KiB oflag=dsync status=progress"
echo "$cmd"
yesno "Do you want to run the command above?" && $cmd
