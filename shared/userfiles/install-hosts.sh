#!/bin/bash

hostname="${1:-$HOST}"
ver="3.11.14"
url="https://raw.githubusercontent.com/StevenBlack/hosts/${ver}/hosts"

curl --connect-timeout 13 --retry 5 --retry-delay 2 "$url" \
	-sS -H "Accept:application/vnd.github.v3.raw" \
	-o /etc/hosts

sed -i "/^127.0.0.1 local$/a 127.0.0.1 host.docker.internal" /etc/hosts
sed -i "/^127.0.0.1 local$/a 127.0.0.1 ${hostname}.localdomain" /etc/hosts
sed -i "/^127.0.0.1 local$/a 127.0.0.1 ${hostname}" /etc/hosts
