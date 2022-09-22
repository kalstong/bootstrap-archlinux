#!/usr/bin/dash

loginctl session-status |
	head -1 |
	awk '{print $1}' |
	xargs loginctl terminate-session
