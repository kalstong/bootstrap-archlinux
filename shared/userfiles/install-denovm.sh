#!/bin/bash

ver="1.8.2"
url="https://github.com/justjavac/dvm/releases/download/v${ver}/dvm-x86_64-unknown-linux-gnu.zip"

curl --connect-timeout 13 --retry 5 --retry-delay 2 "$url" \
	-L -sS -H "Accept:application/vnd.github.v3.raw" \
	-o /tmp/dvm.zip &&

mkdir -p "$DVM_DIR/bin" &&
unzip -o /tmp/dvm.zip -d "$DVM_DIR/bin" &&
chmod u+x "$DVM_DIR/bin/dvm"
mv "$DVM_DIR/bin/dvm" "$DVM_DIR/bin/denovm"
