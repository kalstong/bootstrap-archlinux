#!/usr/bin/dash

dir="$1"
args="$2"

out=$(/usr/bin/git -C "$dir" $args 2> /dev/null)
ret=$?
if [ $ret -eq 0 ] && [ -n "$out" ]; then
	echo "$out" | wc -l
elif [ $ret -eq 0 ] ; then
	echo "0"
else
	echo "?"
fi
