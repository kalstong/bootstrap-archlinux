#!/bin/bash

set -e

ver="0.1.030"
url="https://www.dropbox.com/s/m3m8ar8nknrnggm/jai-beta-1-030.zip?dl=1"

rm -rf /tmp/jai*
echo "==> Downloading JAI v$ver ..."
curl --connect-timeout 13 --retry 5 --retry-delay 2 "$url" \
	-L -sS -o /tmp/jai.zip

echo "==> Installing JAI ..."
unzip /tmp/jai.zip -d /tmp > /dev/null

rm -rf "$JAI_DIR"/*
mkdir -p "$JAI_DIR"

mv /tmp/jai/* "$JAI_DIR"
rm -rf "$JAI_DIR"/bin/{jai.exe,lld-macosx,lld.exe}
mv "$JAI_DIR"/bin/jai-linux "$JAI_DIR"/bin/jai
chmod u+x "$JAI_DIR"/bin/{jai,lld-linux}

rm -rf /tmp/jai*

echo "==> Done."
