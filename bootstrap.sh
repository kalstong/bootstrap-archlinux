#!/bin/bash

# Examples -------------------------------
# long:  $ bash bootstrap.sh --host helium
# short: $ bash bootstrap.sh -h helium
#
# There's also -s or --stepping to pause the execution before every major step.
# Very useful to manually finding issues during the setup.

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd "$scriptdir" > /dev/null
. misc.sh

bt_host=""
bt_reset_raid=""
bt_stepping=""
bt_user=""
while [[ $# -gt 0 ]]
do
	case "$1" in
		-h|--host)
			bt_host="$2"
			shift
			shift
			;;
		-r|--reset-raid)
			bt_reset_raid="--reset-raid"
			shift
			;;
		-s|--stepping)
			bt_stepping="--stepping"
			shift
			;;
		-u|--user)
			bt_user="$2"
			shift
			shift
			;;
		*)
			printwarn "Unknown option: '$1'. Will be ignored."
			shift
			;;
	esac
done

[ ! "$bt_host" ] &&
	printerr "Missing mandatory '-h/--host' option." && exit 1
[ ! "$bt_user" ] &&
	printerr "Missing mandatory '-u/--user' option." && exit 1
[ ! -d "host-$bt_host" ] &&
	printerr "There's no host available with that name: $bt_host." && exit 1

source "host-${bt_host}/system-bootstrap.sh" \
	--host ${bt_host} --user ${bt_user} \
	${bt_stepping} ${bt_reset_raid}

printsucc "\n"
printsucc "The ${bt_host} host configuration finished!"

popd > /dev/null
