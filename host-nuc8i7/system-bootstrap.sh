#!/bin/bash

# --- System Specs ---
# Intel NUC8i7BEH [1]
# CPU: Intel Core i7-8559U @2.70GHz [2]
# RAM: 2x 16GiB DDR4 @2.40GHz-CL14 DC
# GPU: Intel Iris Plus Graphics 655 @300/1200MHz
# SSD: 1TiB M.2 NVMe Intel 660p QLC
#
# [1]: https://ark.intel.com/content/www/us/en/ark/products/126140/intel-nuc-kit-nuc8i7beh.html
# [2]: https://ark.intel.com/content/www/us/en/ark/products/137979/intel-core-i7-8559u-processor-8m-cache-up-to-4-50-ghz.html

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$scriptdir" > /dev/null
. ../misc.sh

bt_host=""
bt_rootdir="$(mktemp -d)"
bt_stepping=""
bt_user=""
while [[ $# -gt 0 ]]
do
	case "$1" in
		-h|--host)
			bt_host="$2"
			shift
			shift
			;;
		-s|--stepping)
			bt_stepping="--stepping"
			shift
			;;
		-u|--user)
			bt_user="$2"
			shift
			shift
			;;
		*)
			printwarn "Unknown option: '$1'. Will be ignored."
			shift
			;;
	esac
done
[ ! "$bt_host" ] && printerr "Missing mandatory '--host' option." && exit 1

printinfo "\n"
printinfo "+ ------------ +"
printinfo "| Erasing disk |"
printinfo "+ ------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
_disk_key="/dev/disk/by-id/usb-General_USB_Flash_Disk_7911020000213736-0:0"
_disk_system="/dev/nvme0n1"

nvme format "$_disk_system" --force --namespace-id 1 --ses 0
sync
partprobe "$_disk_system"

printinfo "\n"
printinfo "+ ----------------- +"
printinfo "| Partitioning disk |"
printinfo "+ ----------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

parted "$_disk_system" mklabel gpt && sync

_starts_at=1
_ends_at=$((${_starts_at} + 512)) # 512MiB boot partition
parted "$_disk_system" mkpart primary "${_starts_at}MiB" "${_ends_at}MiB" set 1 esp on && sync

_starts_at=${_ends_at} # Remaining space as the root partition
parted "$_disk_system" mkpart primary "${_starts_at}MiB" "100%" && sync

printinfo "\n"
printinfo "+ ------------------------------------------------- +"
printinfo "| Formatting volumes and setting up LUKS encryption |"
printinfo "+ ------------------------------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

if [ ! -L "$_disk_key" ]; then
	printinfo "  -> Please insert the main decryption key ..."
	while [ ! -L "$_disk_key" ]; do usleep $((1000 * 100)); done
fi

printinfo "  -> Reading decryption key ..."
dd if="$_disk_key" of=/tmp/main.keyfile \
   skip=$((640 * 1024 * 1024 + 1024 * 2)) \
   ibs=1 count=1024 status=none && sync

sleep 1
printinfo "\n\n  -> Requesting fallback decryption password ..."
askpwd > /tmp/pwd.keyfile

mkfs.fat -F32 "${_disk_system}p1"

printinfo "\n  -> Encrypting root partition ..."
cryptsetup --verbose \
	--batch-mode luksFormat "${_disk_system}p2" /tmp/main.keyfile \
	--type luks2 --sector-size 4096

printinfo "\n  -> Setting fallback decryption password ..."
cryptsetup luksAddKey "${_disk_system}p2" --key-file /tmp/main.keyfile < /tmp/pwd.keyfile
shred --iterations=1 --random-source=/dev/urandom -u --zero /tmp/pwd.keyfile

printinfo "\n  -> Opening the encrypted root partition ..."
cryptsetup --key-file /tmp/main.keyfile \
	--allow-discards \
	--perf-no_read_workqueue \
	--perf-no_write_workqueue \
	open "${_disk_system}p2" root
shred --iterations=1 --random-source=/dev/urandom -u --zero /tmp/main.keyfile

printinfo "\n  -> Formatting the root partition ..."
mkfs.f2fs -O extra_attr,inode_checksum,sb_checksum,encrypt -f /dev/mapper/root

sync
printinfo "\n"
printinfo "+ ------------------- +"
printinfo "| Mounting partitions |"
printinfo "+ ------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
boot_mount_opts=$(grep "/boot" sysfiles/fstab | awk '{print $4}')
root_mount_opts=$(grep "/dev/mapper/root" sysfiles/fstab | awk '{print $4}')

mount -o "$root_mount_opts" /dev/mapper/root "$bt_rootdir" && sync

mkdir -p "$bt_rootdir/boot"
mount -o "$boot_mount_opts" "${_disk_system}p1" "$bt_rootdir/boot"

printinfo "\n"
printinfo "+ --------------------- +"
printinfo "| Updating mirrors list |"
printinfo "+ --------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
cp ../shared/sysfiles/mirrorlist /etc/pacman.d/mirrorlist

printinfo "\n"
printinfo "+ --------------------- +"
printinfo "| Configuring initramfs |"
printinfo "+ --------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

cp ../shared/sysfiles/pacman.conf /etc/pacman.conf
pacstrap -i "$bt_rootdir" mkinitcpio --noconfirm

cp sysfiles/decrypt.hook "$bt_rootdir/etc/initcpio/hooks/decrypt"
cp sysfiles/decrypt.install "$bt_rootdir/etc/initcpio/install/decrypt"

cp "$bt_rootdir/etc/mkinitcpio.conf" "$bt_rootdir/etc/mkinitcpio.conf.bak"
cp sysfiles/mkinitcpio.conf "$bt_rootdir/etc/mkinitcpio.conf"

# The keymap needs to be configured earlier so initramfs uses the correct layout
# for entering the disk decryption password.
mkdir -p "$bt_rootdir/usr/local/share/kbd/keymaps"
{ echo "keycode 58 = Escape";
  echo "altgr keycode 18 = euro";
  echo "altgr keycode 46 = cent"; } > "$bt_rootdir/usr/local/share/kbd/keymaps/uncap.map"
{ echo "keycode 58 = Caps_Lock";
  echo "altgr keycode 18 = euro";
  echo "altgr keycode 46 = cent"; } > "$bt_rootdir/usr/local/share/kbd/keymaps/recap.map"
{ echo "KEYMAP=pt-latin9";
  echo "KEYMAP_TOGGLE=/usr/local/share/kbd/keymaps/uncap.map";
  echo "FONT=ter-116n"; } > "$bt_rootdir/etc/vconsole.conf"

printinfo "\n"
printinfo "+ -------------------------- +"
printinfo "| Installing Pacman packages |"
printinfo "+ -------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

pacman_core=(
	base intel-media-driver intel-ucode linux-lts linux-firmware libva mesa
	sshfs vulkan-intel xf86-video-intel
)
pacman_system=(
	avahi bat bc bluez bspwm cpupower dash dhcpcd dunst efibootmgr exa
	exfatprogs f2fs-tools fd fish fwupd fzf gnome-keyring gptfdisk gnupg
	gocryptfs intel-gpu-tools intel-undervolt iwd libnotify lz4 man-db nss-mdns
	openbsd-netcat parted pbzip2 picom pigz playerctl polybar pulseaudio
	redshift ripgrep sxhkd tint2 tmux unzip usleep x86_energy_perf_policy xclip
	xdg-user-dirs xdg-utils xdotool xorg-server xorg-xinit xorg-xinput
	xorg-xprop xorg-xrandr xorg-xset xorg-xsetroot zip zstd
)
pacman_tools=(
	arch-audit aria2 bash-completion bind bluez-utils btop croc ctop curl ffmpeg
	ffmpeg4.4 firejail freerdp htop inotify-tools iotop jq libva-utils lfs lshw
	lsof mosh neovim nnn openconnect openssh openvpn p7zip pacman-contrib perf
	strace sysbench sysstat time tree turbostat usbutils vkmark
)
pacman_development=(
	base-devel diffutils docker docker-compose git git-delta man-pages python
	python-pip tokei unixodbc vulkan-icd-loader vulkan-mesa-layers
)
pacman_apps=(
	alacritty arandr chromium drawing feh libreoffice-still maim mpv obs-studio
	pavucontrol peek remmina rofi signal-desktop slock sxiv virt-viewer
)
pacman_fonts=(
	noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra terminus-font
	ttf-font-awesome ttf-jetbrains-mono
)

pacman -Syy
pacstrap -i "$bt_rootdir" ${pacman_core[*]} ${pacman_system[*]} \
	${pacman_tools[*]} ${pacman_development[*]} ${pacman_apps[*]} \
	${pacman_apps[*]} ${pacman_fonts[*]} --needed --noconfirm

printinfo "\n"
printinfo "+ ---------------- +"
printinfo "| Setting up fstab |"
printinfo "+ ---------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
cp sysfiles/fstab "$bt_rootdir/etc/fstab"
chmod u=r,g=r,o=r "$bt_rootdir/etc/fstab"

printinfo "\n"
printinfo "+ ---------------------------- +"
printinfo "| Jumping into the chroot jail |"
printinfo "+ ---------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
mkdir -p "$bt_rootdir/tmp/bootstrap"
cp -r {"../host-${bt_host}",../pkgs,../shared,../ssh,../misc.sh} "$bt_rootdir/tmp/bootstrap"

mount proc "$bt_rootdir/proc/" -t proc  -o nosuid,noexec,nodev
mount sys  "$bt_rootdir/sys/"  -t sysfs -o nosuid,noexec,nodev,ro
[ -d "${bt_rootdir}/sys/firmware/efi/efivars" ] &&
	mount efivarfs "${bt_rootdir}/sys/firmware/efi/efivars" -t efivarfs -o nosuid,noexec,nodev
mount udev   "$bt_rootdir/dev/"    -t devtmpfs -o mode=0755,nosuid
mount devpts "$bt_rootdir/dev/pts" -t devpts   -o mode=0620,gid=5,nosuid,noexec
mount shm    "$bt_rootdir/dev/shm" -t tmpfs    -o mode=1777,nosuid,nodev
mount /run   "$bt_rootdir/run" --bind

cp ../shared/sysfiles/resolv.conf "$bt_rootdir/etc/resolv.conf"
chroot "$bt_rootdir" \
	/usr/bin/bash "/tmp/bootstrap/host-${bt_host}/system-configure.sh" \
	--host ${bt_host} --user ${bt_user} ${bt_stepping}

printinfo "\n"
printinfo "+ --------------------- +"
printinfo "| Unmounting partitions |"
printinfo "+ --------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
killall -q gpg-agent dirmngr
sync

umount "$bt_rootdir/boot"
sync

umount -R "$bt_rootdir"
cryptsetup close root

popd > /dev/null
