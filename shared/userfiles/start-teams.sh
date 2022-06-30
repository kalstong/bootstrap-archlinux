#!/bin/bash

chromium --app="https://teams.microsoft.com" &
pid=$!

sleep 5 && xdotool search --name "Teams" windowsize 950 680
wait $pid
