#!/bin/bash


[ "$1" = "--tools" ] && {
	tools_ver="100.6.0";
	tools_pkg="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian11-x86_64-${tools_ver}.tgz";

	rm -rf /tmp/mongodb-tools/ ;

	echo "Downloading $tools_pkg ..." &&
	curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -L \
		"$tools_pkg" -o /tmp/mongodb-tools.tgz &&

	echo "Installing $tools_pkg ..." &&
	mkdir -p /tmp/mongodb-tools &&
	tar fvxz /tmp/mongodb-tools.tgz -C /tmp/mongodb-tools/ \
		--wildcards  '*/bin/*' --strip-components=1 &&
	mv /tmp/mongodb-tools/bin/mongo* "$HOME/.local/bin/"

	rm -f /tmp/mongodb-tools.tgz &&
	rm -rf /tmp/mongodb-tools/ ;

	exit 0;
}

[ "$1" = "--compass" ] && {
	compass_ver="1.33.1";
	compass_pkg="https://github.com/mongodb-js/compass/releases/download/v${compass_ver}/mongodb-compass-isolated-${compass_ver}-linux-x64.tar.gz";
	compass_icon="https://raw.githubusercontent.com/mongodb-js/compass/main/packages/compass/src/app/images/compass-dialog-icon.png";

	rm -rf /tmp/mongodb* ;

	echo "Downloading $compass_pkg ..." &&
	curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -H 'Accept:application/vnd.github.v3.raw' \
		-L "$compass_pkg" -o /tmp/mongodb-compass.tgz &&
	curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -H 'Accept:application/vnd.github.v3.raw' \
		-L "$compass_icon" -o /tmp/mongodb-compass.png &&

	mkdir -p /tmp/mongodb-tools /tmp/mongodb-compass &&
	tar fvxz /tmp/mongodb-compass.tgz -C /tmp/mongodb-compass/ \
		--wildcards  'MongoDB Compass Isolated Edition-linux-x64/*' --strip-components=1 &&

	rm -rf "$HOME/.local/bin/mongodb-compass" &&
	mkdir -p "$HOME/.local/bin/mongodb-compass" &&
	mv /tmp/mongodb-compass/* "$HOME/.local/bin/mongodb-compass" &&
	mkdir -p "$HOME/.icons" &&
	mv /tmp/mongodb-compass.png "$HOME/.icons" &&
	mkdir -p "$HOME/.local/share/applications" &&
	echo "[Desktop Entry]
Exec=\"$HOME/.local/bin/mongodb-compass/MongoDB Compass Isolated Edition\" --disable-features=UseChromeOSDirectVideoDecoder,UseSkiaRenderer --disable-gpu-driver-bug-workarounds --enable-accelerated-mjpeg-decode --enable-accelerated-video-decode --enable-features=CanvasOopRasterization,ParallelDownloading,UseVulkan,VaapiVideoDecoder,VaapiVideoEncoder --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-oop-rasterization --enable-zero-copy --ignore-gpu-blocklist --use-vulkan
Type=Application
Categories=Development
Name=MongoDB Compass Isolated Edition
Icon=mongodb-compass" > "$HOME/.local/share/applications/mongodb-compass.desktop";

	rm -rf /tmp/mongodb* ;
}
