#!/usr/bin/dash

updates=$(checkupdates 2> /dev/null)
ret=$?

if [ $ret -eq 0 ]; then
	echo $(echo -e "$updates" | wc -l)
else
	echo "?"
fi
