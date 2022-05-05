#!/bin/bash

chromium --app="https://open.spotify.com" &
pid=$!

sleep 3 && xdotool search --name "Spotify" windowsize 1030 815
wait $pid
