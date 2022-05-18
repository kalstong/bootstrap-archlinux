#!/bin/bash

dvm_version="1.3.1"

[ -d "${DVM_ROOT}/.git" ] &&
	cd "$DVM_ROOT" &&
	git fetch --all --tags &&
	git checkout "tags/${dvm_version}" &&
	cd - &&
	exit 0

rm -rf "$DVM_ROOT" &&
git clone https://github.com/cbracken/dvm.git "$DVM_ROOT" &&
cd "$DVM_ROOT" &&
git checkout "tags/${dvm_version}" &&
cd -
