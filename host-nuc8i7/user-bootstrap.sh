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
sudo chown -R $bt_user:$bt_user userfiles ../shared
sudo chmod -R u=rw,g=r,o=r userfiles ../shared
sudo chmod u+x userfiles ../shared ../shared/userfiles

. userfiles/.bashrc

mkdir "$HOME/.gnupg" "$HOME/.ssh"
chmod u=rwx,g=,o= "$HOME/.gnupg" "$HOME/.ssh"
mkdir -p "$HOME/.config/fontconfig"
mkdir -p "$HOME/.local/bin/go"
mkdir -p "$HOME/.local/share/xorg"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p {"$AUR","$CODE","$DOWNLOADS","$FILES","$NOTES"}
mkdir -p {"$RECORDINGS","$SCREENSHOTS","$TRASH","$WALLPAPERS","$WORK"}
mkdir -p {"$GOCACHE","$GOMODCACHE","$GOPATH","$GOROOT"}
mkdir -p {"$NPM_CONFIG_CACHE","$NVM_DIR","$YARN_CACHE_FOLDER"}
mkdir -p "$CACHE"/docker

chattr -R +c {"$GOMODCACHE","$NPM_CONFIG_CACHE","$NVM_DIR","$YARN_CACHE_FOLDER"}
sudo mkdir -p "$MOUNT"
sudo chown $bt_user:$bt_user "$MOUNT"
sudo chmod u=rwx,g=rx,o= userfiles "$MOUNT"

printinfo "\n"
printinfo "+ --------------- +"
printinfo "| Creating groups |"
printinfo "+ --------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
sudo usermod -aG docker ${bt_user}
sudo usermod -aG lp ${bt_user}
sudo usermod -aG video ${bt_user}

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
pip3 install --user flashfocus pynvim pywal
sudo -H pip3 install vpn-slice

printinfo "\n"
printinfo "+ ------------ +"
printinfo "| Installing g |"
printinfo "+ ------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
. ../shared/userfiles/install-g.sh

printinfo "\n"
printinfo "+ ------------------------------ +"
printinfo "| Installing NVM, NodeJS and NPM |"
printinfo "+ ------------------------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
. ../shared/userfiles/install-nvm.sh

NVM_SYMLINK_CURRENT="true"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
nvm install --lts=fermium
nvm use default

printinfo "\n"
printinfo "+ ----------------------- +"
printinfo "| Installing AUR packages |"
printinfo "+ ----------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

archl_aur=(
	brave-bin@master firefox-esr-bin@master polybar@master
)

cd "$AUR"
for pkg in ${archl_aur[*]}
do
	_name=${pkg%%@*}
	_tag=${pkg##*@}
	_repo="https://aur.archlinux.org/${_name}.git"

	git clone "$_repo" || continue

	cd "$_name"
	git checkout "$_tag"
	makepkg -sirc --noconfirm --needed || true
	git clean -fddx
	cd ..
done
cd "$script_path"

printinfo "\n"
printinfo "+ ---------------------------------- +"
printinfo "| Installing NERDFont JetBrains Mono |"
printinfo "+ ---------------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
. ../shared/userfiles/install-nf-jetbrainsmono.sh

printinfo "\n"
printinfo "+ ------------------------ +"
printinfo "| Installing Neovim pugins |"
printinfo "+ ------------------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
nvim +PlugInstall +qa


popd > /dev/null
