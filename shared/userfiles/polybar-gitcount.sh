#!/usr/bin/dash

dir="$1"
args="$2"

out=$(/usr/bin/git -C "$dir" $args 2> /dev/null)
ret=$?
if [ $ret -eq 0 ]; then
	echo $(printf "%s" "$out" | wc -l)
else
	echo "?"
fi
