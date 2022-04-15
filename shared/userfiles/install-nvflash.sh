#!/bin/bash

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$scriptdir" > /dev/null

version="5.692.0"

sha256sum -c "nvflash-${version}.sha256" &&
unzip -C -j -o "nvflash-${version}.zip" "x64/nvflash" -d "$HOME/.local/bin/" &&
chmod u+x "$HOME/.local/bin/nvflash"

popd > /dev/null
