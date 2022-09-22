#!/usr/bin/dash

args="$1"
dir="$2"

pushd "$dir" > /dev/null
out=$(/usr/bin/git $args 2> /dev/null)
ret=$?
if [ $ret -eq 0 ]; then
	echo $(printf "%s" "$out" | wc -l)
else
	echo "?"
fi
popd > /dev/null
