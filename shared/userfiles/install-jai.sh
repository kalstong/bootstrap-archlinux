#!/bin/bash

set -e

ver="0.1.031"
url="https://www.dropbox.com/s/4lfvceze2x8ra95/jai-beta-1-031.zip?dl=1"

[ ! -v JAI_DIR ] && echo "==> ERROR: \$JAI_DIR is not defined." && exit 1


rm -rf /tmp/jai/ /tmp/jai.zip
echo "==> Downloading JAI v$ver ..."
curl --connect-timeout 13 --location --progress-bar --retry 5 --retry-delay 2 \
	"$url" --output /tmp/jai.zip

echo "==> Installing JAI ..."
unzip /tmp/jai.zip -d /tmp > /dev/null

[ -d "$JAI_DIR" ] && rm -rf "$JAI_DIR"
mkdir -p "$JAI_DIR"

mv /tmp/jai/* "$JAI_DIR"
mv "$JAI_DIR"/bin/jai-linux "$JAI_DIR"/bin/jai

rm -rf "$JAI_DIR"/bin/{jai.exe,lld-macosx,lld.exe}
chmod u+x "$JAI_DIR"/bin/{jai,lld-linux}

echo "==> Removing temporary files ..."
rm -rf /tmp/jai/ /tmp/jai.zip

echo "==> Done."
