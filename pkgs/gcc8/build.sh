#!/bin/bash

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$scriptdir" > /dev/null

makepkg -sirc --nocheck

popd > /dev/null
