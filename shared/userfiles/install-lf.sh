#!/bin/bash

version="r27";
package="https://github.com/gokcehan/lf/releases/download/${version}/lf-linux-amd64.tar.gz";

rm -rf /tmp/lf
rm -rf /tmp/lf-amd64.tar.gz

echo "Downloading lf ${version} ...";
curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 \
	-H 'Accept:application/vnd.github.v3.raw' \
	-L "$package" -o /tmp/lf-amd64.tar.gz &&

echo "Extracting lf ...";
tar fvxz /tmp/lf-amd64.tar.gz -C /tmp/ &&
mv /tmp/lf "${HOME}/.local/bin/"

rm -rf /tmp/lf
rm -rf /tmp/lf-amd64.tar.gz
