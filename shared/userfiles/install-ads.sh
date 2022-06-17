#!/bin/bash

rm -rf /tmp/ads*

ads_pkg_version="1.37.0"
ads_pkg="https://go.microsoft.com/fwlink/?linkid=2198879"
ads_ico="https://raw.githubusercontent.com/microsoft/azuredatastudio/main/resources/linux/code.png"

echo "Downloading $ads_pkg ..." &&
curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -L "$ads_pkg" -o /tmp/ads.tar.gz &&
curl -sS --connect-timeout 13 --retry 5 --retry-delay 2 -H 'Accept:application/vnd.github.v3.raw' \
	-L "$ads_ico" -o /tmp/ads.png &&

mkdir -p /tmp/ads &&
tar fvxz /tmp/ads.tar.gz -C /tmp/ads/ \
	--wildcards  'azuredatastudio-linux-x64/*' --strip-components=1 &&

rm -rf "$HOME/.local/bin/ads" &&
mkdir -p "$HOME/.local/bin/ads" &&
mv /tmp/ads/* "$HOME/.local/bin/ads" &&
mkdir -p "$HOME/.icons" &&
mv /tmp/ads.png "$HOME/.icons" &&
mkdir -p "$HOME/.local/share/applications" &&
cat <<EOF > "$HOME/.local/share/applications/ads.desktop"
[Desktop Entry]
Exec=$HOME/.local/bin/ads/azuredatastudio --disable-features=UseChromeOSDirectVideoDecoder,UseSkiaRenderer --disable-gpu-driver-bug-workarounds --enable-accelerated-mjpeg-decode --enable-accelerated-video-decode --enable-features=CanvasOopRasterization,ParallelDownloading,UseVulkan,VaapiVideoDecoder,VaapiVideoEncoder --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-oop-rasterization --enable-zero-copy --ignore-gpu-blocklist --use-vulkan
Type=Application
Categories=Development
Name=Azure Data Studio
Icon=ads
EOF

mkdir -p "$XDG_CONFIG_HOME/azuredatastudio/User/"
cat <<EOF > "$XDG_CONFIG_HOME/azuredatastudio/User/settings.json"
{
	"telemetry.enableCrashReporter": false,
	"telemetry.enableTelemetry": false,
	"update.mode": "none",
	"workbench.enablePreviewFeatures": false
}
EOF

rm -rf /tmp/ads*
