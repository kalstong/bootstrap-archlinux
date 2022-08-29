#!/usr/bin/dash

updates=$(checkupdates 2> /dev/null)
ret=$?

if [ $ret -eq 0 ] || [ $ret -eq 2 ]; then
	[ -n "$updates" ] && echo $(printf "%s\n" "$updates" | wc -l) && exit 0
	[ -z "$updates" ] && echo "0" && exit 0
else
	echo "?"
fi
