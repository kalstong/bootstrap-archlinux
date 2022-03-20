#!/usr/bin/env bash

[ ! -f "$GOPATH/bin/g" ] && {
	mkdir -p "$GOPATH/bin" &&
	git clone https://github.com/stefanmaric/g -b 0.9.0 /tmp/g &&
	mv /tmp/g/bin/g "$GOPATH/bin/" &&
	chmod u+x "$GOPATH/bin/g";
}

[ -n "$1" ] && . "$GOPATH/bin/g" -y install "$1"
