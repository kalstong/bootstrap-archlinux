#!/bin/bash

version="v0.39.1"

[ -d "${NVM_DIR}/.git" ] &&
	cd "$NVM_DIR" &&
	git fetch --all --tags &&
	git checkout "tags/${version}" &&
	exit 0

rm -rf "$NVM_DIR" &&
git clone https://github.com/nvm-sh/nvm.git --branch "$version" "$NVM_DIR"
