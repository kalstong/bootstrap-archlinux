#!/bin/bash

set -e

ver="v2.2.2"
url="https://github.com/ryanoasis/nerd-fonts/releases/download/${ver}/FontPatcher.zip"

rm -rf /tmp/FontPatcher.zip /tmp/fontpatcher

curl --connect-timeout 13 --retry 5 --retry-delay 2 "$url" \
	-L -H "Accept:application/vnd.github.v3.raw" \
	-o /tmp/FontPatcher.zip

mkdir -p /tmp/fontpatcher
unzip /tmp/FontPatcher.zip -d /tmp/fontpatcher

for file in /usr/share/fonts/TTF/JetBrainsMonoNL*; do
	fontforge -script /tmp/fontpatcher/font-patcher $file \
		--complete  --progressbars --use-single-width-glyphs \
		--out $HOME/.local/share/fonts/
done

rm -rf /tmp/FontPatcher.zip /tmp/fontpatcher
