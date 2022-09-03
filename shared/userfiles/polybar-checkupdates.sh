#!/usr/bin/dash

ret=1
while [ $ret -eq 1 ]
do
	updates=$(checkupdates 2> /dev/null)
	ret=$?
	sleep 5
done

[ -n "$updates" ] &&
	echo $(printf "%s\n" "$updates" | wc -l) &&
	exit 0

echo "0"
