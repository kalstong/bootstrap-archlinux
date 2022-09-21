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
[ -z "$bt_host" ] && printerr "Missing mandatory '-h/--host' option." && exit 1
[ -z "$bt_user" ] && printerr "Missing mandatory '-u/--user' option." && exit 1

printinfo "\n"
printinfo "+ -------------------- +"
printinfo "| Creating directories |"
printinfo "+ -------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
sudo chown -R $bt_user:$bt_user userfiles ../pkgs ../shared
sudo chmod -R u=rw,g=r,o=r userfiles ../pkgs ../shared
sudo chmod u+x userfiles ../pkgs ../pkgs/* ../shared ../shared/userfiles

. userfiles/.bashrc

mkdir "$HOME/.gnupg" "$HOME/.ssh"
chmod u=rwx,g=,o= "$HOME/.gnupg" "$HOME/.ssh"
mkdir -p "$HOME/.config/fontconfig"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p {"$AUR","$DOWNLOADS","$FILES","$NOTES","$TRASH"}
mkdir -p "$CACHE"/docker

sudo mkdir -p "$MOUNT"
sudo chown $bt_user:$bt_user "$MOUNT"
sudo chmod u=rwx,g=rx,o= userfiles "$MOUNT"

sudo mkdir -p "$D1"
sudo chown $bt_user:$bt_user "$D1"
sudo chmod u=rwx,g=rx,o= "$D1"

printinfo "\n"
printinfo "+ --------------- +"
printinfo "| Creating groups |"
printinfo "+ --------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
sudo usermod -aG docker ${bt_user}
sudo usermod -aG lp ${bt_user}

printinfo "\n"
printinfo "+ --------------------- +"
printinfo "| Installing user files |"
printinfo "+ --------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
. user-configure.sh

printinfo "\n"
printinfo "+ ----------------------- +"
printinfo "| Installing pip packages |"
printinfo "+ ----------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
pip3 install --user wheel
pip3 install --user pynvim

printinfo "\n"
printinfo "+ ------------------------ +"
printinfo "| Installing Neovim pugins |"
printinfo "+ ------------------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
nvim +PlugInstall +UpdateRemotePlugins +sleep1 +qa


popd > /dev/null
