#!/usr/bin/dash

printstatus () {
	echo "$1" | grep --silent "source" && {
		sourcesMuteStates=""
		pactlListSources="$(pactl list sources)"
		for isMuted in $(echo "$pactlListSources" | grep 'Mute:' | awk '{print $2}')
		do
			[ -n "$sourcesMuteStates" ] &&
				sourcesMuteStates="$sourcesMuteStates $isMuted" ||
				sourcesMuteStates="$isMuted"
		done

		allSinksMuted="yes"
		idx=1
		for monitorOfSync in $(echo "$pactlListSources" | grep 'Monitor of Sink:' | awk '{print $4}')
		do
			sourceIsMuted="$(echo "$sourcesMuteStates" | cut -d ' ' -f $((idx)))"
			sourceIsSink="$(echo "$monitorOfSync" | grep --silent "n/a" && echo "yes" || echo "no")"
			idx=$((idx + 1))
			[ "$sourceIsMuted" = "no" ] && [ "$sourceIsSink" = "yes" ] && allSinksMuted="no"
			[ "$allSinksMuted" = no ] && break;
		done

		[ "$allSinksMuted" = "yes" ] &&
			/usr/bin/printf '\uf131\n' ||
			/usr/bin/printf '\uf130\n';
	}
}

# NOTE: Need to call `printstatus' once to paint the mute/unmute icon
# because the procedure won't be called until there's a `source' event
# from Pulse Audio.
printstatus "source"

pactl subscribe | {
	while read evt; do printstatus "$evt"; done
}
