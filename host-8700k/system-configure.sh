#!/bin/bash

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_path" > /dev/null
. ../misc.sh

bt_host=""
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
[ -z "$bt_host" ] && echo "Missing mandatory '-h/--host' option." && exit 1
[ -z "$bt_host" ] && echo "Missing mandatory '-u/--user' option." && exit 1

printinfo "\n"
printinfo "+ ------------------------------- +"
printinfo "| Installing and configuring GRUB |"
printinfo "+ ------------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

grub-install \
	--target=x86_64-efi \
	--efi-directory="/boot/efi" \
	--bootloader-id=arch_grub \
	--recheck && sync

cp sysfiles/grub.cfg /boot/grub/grub.cfg
chmod u=rw,g=r,o=r /boot/grub/grub.cfg

printinfo "\n"
printinfo "+ --------------------------------- +"
printinfo "| Configuring system authentication |"
printinfo "+ --------------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

cp /etc/pam.d/passwd /etc/pam.d/passwd.bak
cp /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
cp /etc/pam.d/system-login /etc/pam.d/system-login.bak

cp ../shared/sysfiles/passwd /etc/pam.d/passwd
cp ../shared/sysfiles/system-auth /etc/pam.d/system-auth
cp ../shared/sysfiles/system-login /etc/pam.d/system-login
chmod u=r,g=r,o=r /etc/pam.d/passwd \
                  /etc/pam.d/system-auth \
                  /etc/pam.d/system-login

printinfo "\n"
printinfo "+ -------------------------------------------------------- +"
printinfo "| Configuring mirrors, timezone, clock, locales and pacman |"
printinfo "+ -------------------------------------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

cp ../shared/sysfiles/mirrorlist /etc/pacman.d/mirrorlist
chmod u=rw,g=r,o=r /etc/pacman.d/mirrorlist

rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime

sed -i -r '/#en_US.UTF-8 UTF-8/s/^#*//g' /etc/locale.gen
sed -i -r '/#pt_PT.UTF-8 UTF-8/s/^#*//g' /etc/locale.gen
locale-gen

{ echo "LANG=en_US.UTF-8";
  echo "LC_ALL=en_US.UTF-8";
  echo "LC_CTYPE=pt_PT.UTF-8";
  echo "LC_MEASUREMENT=pt_PT.UTF-8";
  echo "LC_MONETARY=pt_PT.UTF-8";
  echo "LC_NUMERIC=pt_PT.UTF-8";
  echo "LC_TELEPHONE=pt_PT.UTF-8";
  echo "LC_TIME=pt_PT.UTF-8"; } > /etc/locale.conf

echo "KEYMAP=pt-latin1" > /etc/rc.conf

cp /etc/pacman.conf /etc/pacman.conf.bak
cp ../shared/sysfiles/pacman.conf /etc/pacman.conf

printinfo "\n"
printinfo "+ -------------------- +"
printinfo "| Configuring Hostname |"
printinfo "+ -------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

echo "$bt_host" > /etc/hostname
{ echo -e "127.0.0.1\tlocalhost";
  echo -e "::1\tlocalhost";
  echo -e "127.0.0.1\thost.docker.internal";
  echo -e "127.0.0.1\t${bt_host}.localdomain\t${bt_host}"; } > /etc/hosts

printinfo "\n"
printinfo "+ -------------------- +"
printinfo "| Configuring services |"
printinfo "+ -------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

systemctl enable avahi-daemon.service
systemctl enable bluetooth.service
systemctl enable dhcpcd.service
systemctl enable docker.service
systemctl enable fstrim.timer
systemctl enable iwd.service
systemctl enable sshd.service

# fscrypt setup
# fscrypt /mnt/d1

cp /usr/share/doc/avahi/ssh.service /etc/avahi/services
cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
_mdns_config="files mymachines myhostname mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns"
sed -i "s/hosts:.*/hosts: $_mdns_config/" /etc/nsswitch.conf

mkdir -p /etc/bluetooth
cp ../shared/sysfiles/bluetooth.conf /etc/bluetooth/main.conf

_dns_ipv4="1.1.1.1 1.0.0.1"
_dns_ipv6="2606:4700:4700::1111 2606:4700:4700::1001"
_dns="static domain_name_servers=${_dns_ipv4} ${_dns_ipv6}"
{ echo "";
  echo "interface enp0s31f6";
  echo "${_dns}";
  echo "";
  echo "interface wlan0";
  echo "${_dns}"; } >> /etc/dhcpcd.conf

sudo mkdir -p /etc/docker
echo "{\"data-root\": \"/home/$bt_user/.cache/docker\"}" > /etc/docker/daemon.json

cp /etc/fwupd/uefi_capsule.conf /etc/fwupd/uefi_capsule.conf.bak
cp ../shared/sysfiles/fwupd.conf /etc/fwupd/uefi_capsule.conf

cp ../shared/sysfiles/igvt.conf /etc/modules-load.d/

mkdir -p /etc/iwd &&
	cp ../shared/sysfiles/iwd.conf /etc/iwd/main.conf

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cp ../shared/sysfiles/sshd_config /etc/ssh/sshd_config
sed -i -r "s/<bt_user>/$bt_user/" /etc/ssh/sshd_config

cp /etc/makepkg.conf /etc/makepkg.conf.bak
cp ../shared/sysfiles/makepkg.conf /etc/makepkg.conf

num_logical_cores="$(grep "^processor" /proc/cpuinfo | wc -l)"
num_physical_cores="$(grep -m 1 -oP "cpu cores\s*:\s*\K\d+" /proc/cpuinfo)"
sed -i -r "s/<max_make_jobs>/-j$num_physical_cores/" /etc/makepkg.conf

cp /etc/sudoers /etc/sudoers.bak
cp ../shared/sysfiles/sudoers /etc/sudoers
sed -i -r "s|<sudo-timeout-min>|10|" /etc/sudoers
sed -i -r "s|<bt_user>|$bt_user|" /etc/sudoers
chown --changes root:root /etc/sudoers
chmod --changes u=r,g=r,o= /etc/sudoers

sed -i -r 's/#SystemMaxUse=/SystemMaxUse=1G/' /etc/systemd/journald.conf
sed -i -r 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
# echo "vm.vfs_cache_pressure=90" >> /etc/sysctl.d/99-swappiness.conf

# NOTE: This is hack to force-unload the NVIDIA modules during
# system shutdown because they're preventing systemd from closing some mounts.
# For more details: https://bugs.archlinux.org/task/63697#comment203882
cp sysfiles/nvidia.shutdown /usr/lib/systemd/system-shutdown/
chmod a+x /usr/lib/systemd/system-shutdown/nvidia.shutdown

cp sysfiles/xorg.conf /etc/X11/xorg.conf.d/

printinfo "\n"
printinfo "+ --------------------- +"
printinfo "| Creating user account |"
printinfo "+ --------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

echo "/usr/bin/bash" >> /etc/shells
chsh -s "/usr/bin/bash"

useradd --create-home --groups users,wheel --shell "/usr/bin/bash" $bt_user
passwd --delete root
passwd --delete "$bt_user"

chown "${bt_user}:${bt_user}" "/home/${bt_user}"
chown "${bt_user}:${bt_user}" "/mnt/d1"
chmod u=rwx,g=rx,o= "/home/${bt_user}"
chmod u=rwx,g=rx,o= "/mnt/d1"

printinfo "\n"
printinfo "+ ---------------------------- +"
printinfo "| Configuring the user account |"
printinfo "+ ---------------------------- +"
chown "${bt_user}:${bt_user}" user-*.sh
su -s /bin/bash \
   -c "cd /tmp/bootstrap/ && . host-${bt_host}/user-bootstrap.sh -h ${bt_host} -u ${bt_user} ${bt_stepping}" \
   --login ${bt_user}

printinfo "\n"
printinfo "+ -------------------------- +"
printinfo "| Setting accounts passwords |"
printinfo "+ -------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

printwarn "Set root password!"
_pwd_status=""
while [ ! "$_pwd_status" ]; do
	passwd root
	[ $? -eq 0 ] && _pwd_status="ok"
done

printwarn "Set ${bt_user} password!"
_pwd_status=""
while [ ! "$_pwd_status" ]; do
	passwd ${bt_user}
	[ $? -eq 0 ] && _pwd_status="ok"
done

popd > /dev/null
