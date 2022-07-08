#!/bin/bash

set -e

fvm_ver="2.4.1";
fvm_pkg="https://github.com/fluttertools/fvm/releases/download/${fvm_ver}/fvm-${fvm_ver}-linux-x64.tar.gz";

rm -rf /tmp/fvm*

echo "==> Downloading FVM v$fvm_ver ..."
curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 \
	-H 'Accept:application/vnd.github.v3.raw' \
	-L "$fvm_pkg" -o /tmp/fvm.tar.gz

echo "==> Installing FVM ..."
tar fvxz /tmp/fvm.tar.gz -C /tmp/ --wildcards 'fvm/fvm' --strip-components=1
mv /tmp/fvm "${HOME}/.local/bin/"
rm -rf /tmp/fvm*

echo "==> Done."
