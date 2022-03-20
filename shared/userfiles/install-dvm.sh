#!/bin/bash

dvm_version="v1.5.4"
dvm_url="https://github.com/justjavac/dvm/releases/download/$dvm_version/dvm-x86_64-unknown-linux-gnu.zip"

echo "Downloading DVM $dvm_version ..." &&
curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -H 'Accept:application/vnd.github.v3.raw' \
	-L "$dvm_url" -o "/tmp/dvm-$dvm_version.zip" &&

echo "Extracting /tmp/dvm-$dvm_version.zip ..." &&
unzip /tmp/dvm-$dvm_version.zip dvm -d /tmp

echo "Installing DVM $dvm_version ..." &&
mv /tmp/dvm
rm -f /tmp/dvm "/tmp/${dvm_version}.zip"
