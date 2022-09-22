#!/usr/bin/dash

dir="$1"
args="$2"

count () {
	out=$(/usr/bin/git -C "$dir" $args 2> /dev/null)
	ret=$?
	if [ $ret -eq 0 ] && [ -n "$out" ]; then
		echo "$out" | wc -l
	elif [ $ret -eq 0 ] ; then
		echo "0"
	else
		echo "?"
	fi
}

count
/usr/bin/inotifywait \
	--monitor "${dir}/.git/refs/heads" \
	--monitor "${dir}/.git/refs/remotes" \
	--recursive \
	--event create --event modify --event delete 2> /dev/null |
	while read directory action file; do
		# echo "'directory'/'$file' via '$action'"
		count
	done
