#!/usr/bin/dash

updates=$(checkupdates 2> /dev/null)
ret=$?

if [ $ret -eq 0 ] || [ $ret -eq 2 ]; then
	echo $(printf "%s" "$updates" | wc -l)
else
	echo "?"
fi
