#!/bin/bash

chromium --app="https://teams.microsoft.com" &
pid=$!

sleep 2 && xdotool search --name "Teams" windowsize 950 680
wait $pid
