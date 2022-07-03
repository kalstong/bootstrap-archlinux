#!/bin/bash

set -e

ver="0.1.030"
url="https://www.dropbox.com/s/m3m8ar8nknrnggm/jai-beta-1-030.zip?dl=1"

rm -rf /tmp/jai*
echo "Downloading JAI v$ver ..."
curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -L "$url" -o /tmp/jai.zip
unzip /tmp/jai.zip -d /tmp

mkdir -p "$JAI_DIR"
rm -rf "$JAI_DIR"/*
mv /tmp/jai/* "$JAI_DIR"
rm -rf "$JAI_DIR"/{jai.exe,lld-macosx,lld.exe}
mv "$JAI_DIR"/bin/jai-linux "$JAI_DIR"/bin/jai
