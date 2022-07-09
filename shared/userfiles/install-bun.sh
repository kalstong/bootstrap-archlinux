#!/bin/bash

set -e

ver="0.1.2"
url="https://github.com/Jarred-Sumner/bun/releases/download/bun-v${ver}/bun-linux-x64.zip"

rm -rf /tmp/bun*

echo "==> Downloading bun v${ver} ..."
curl --connect-timeout 13 --retry 5 --retry-delay 2 "$url" \
	-L -sS -H "Accept:application/vnd.github.v3.raw" \
	-o /tmp/bun.zip

echo "==> Installing bun ..."
rm -rf "$BUN_INSTALL/bin"
mkdir -p "$BUN_INSTALL/bin"
unzip -C -j -o /tmp/bun.zip "bun-linux-x64/bun" -d "$BUN_INSTALL/bin"
chmod u+x "$BUN_INSTALL/bin/bun"

rm -rf /tmp/bun*

echo "==> Done."
