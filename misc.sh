color_default="\033[0m"
color_red="\033[0;31m"
color_green="\033[0;32m"
color_orange="\033[0;33m"
color_blue="\033[0;36m"

function printinfo { >&2 echo -e "${color_blue}$1${color_default}"; }
function printsucc { >&2 echo -e "${color_green}$1${color_default}"; }
function printwarn { >&2 echo -e "${color_orange}$1${color_default}"; }
function printerr  { >&2 echo -e "${color_red}$1${color_default}"; }

function yesno {
	local answer
	while true; do
		read -p "$* [Y/n]: " answer
		case $answer in
			Y) true && return;;
			n) false || return;;
		esac
	done
}

function askpwd {
	local pwd1="pwd1"
	local pwd2="pwd2"
	while [ "$pwd1" != "$pwd2" ]; do
		read -s -p Password: pwd1
		>&2 echo
		read -s -p Confirm: pwd2
		>&2 echo
		[ "$pwd1" != "$pwd2" ] && printwarn "Passwords don't match. Enter them again."
	done
	printf "$pwd1"
}

function dirHasFiles {
	[ -d "$1" ] && [ "$(/usr/bin/ls -A "$1")" ]
}

