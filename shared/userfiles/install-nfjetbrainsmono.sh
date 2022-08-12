#!/bin/bash

version="2.2.0-RC"
url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/JetBrainsMono.zip"

echo "Downloading $url ..." &&
curl --connect-timeout 13 --retry 5 --retry-delay 2 -L "$url" -o /tmp/nf-jetbrainsmono.zip &&
unzip -o /tmp/nf-jetbrainsmono.zip -d "$HOME/.local/share/fonts/" &&
fc-cache --force
