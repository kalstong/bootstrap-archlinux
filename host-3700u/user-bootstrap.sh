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
mkdir -p "$HOME/.local/bin/go"
mkdir -p "$HOME/.local/share/xorg"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p {"$AUR","$CODE","$DOWNLOADS","$FILES","$NOTES"}
mkdir -p {"$RECORDINGS","$SCREENSHOTS","$TRASH","$WALLPAPERS","$WORK"}
mkdir -p {"$ASDF_DATA_DIR","$GOCACHE","$GOMODCACHE","$GOPATH","$GOROOT"}
mkdir -p {"$NPM_CONFIG_CACHE","$YARN_CACHE_FOLDER"}
mkdir -p "$CACHE"/docker
mkdir -p "$CACHE"/firejail.postman

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
printinfo "+ ----------------------- +"
printinfo "| Installing AUR packages |"
printinfo "+ ----------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

aur_pkgs=(
	asdf-vm@master brave-bin@master postman-bin@master
)

cd "$AUR"
for pkg in ${aur_pkgs[*]}
do
	_name=${pkg%%@*}
	_tag=${pkg##*@}
	_repo="https://aur.archlinux.org/${_name}.git"

	git clone "$_repo" || continue

	cd "$_name"
	git checkout "$_tag"
	makepkg -sirc --noconfirm --needed || true
	cd ..
done
cd "$script_path"

printinfo "\n"
printinfo "+ ----------------------- +"
printinfo "| Installing ASDF Plugins |"
printinfo "+ ----------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

. "${HOME}"/.bashrc

asdf_plugins=(
	"nodejs:14"
)

for plugin in ${asdf_plugins[*]}
do
	_name=${plugin%%:*}
	_ver=${plugin##*:}
	asdf plugin-add "${_name}"
	asdf install "${_name}" "latest:${_ver}"
	asdf global "${_name}" "latest:${_ver}"
done

printinfo "\n"
printinfo "+ ----------------------- +"
printinfo "| Installing NPM packages |"
printinfo "+ ----------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }

npm_pkgs=(
	bash-language-server
	typescript
	typescript-language-server
	vim-language-server
	yarn
)
npm install -g ${npm_pkgs[*]}

printinfo "\n"
printinfo "+ -------------------- +"
printinfo "| Installing NERD Font |"
printinfo "+ -------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
. ../shared/userfiles/install-nf.sh

printinfo "\n"
printinfo "+ ------------------------ +"
printinfo "| Installing Neovim pugins |"
printinfo "+ ------------------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
nvim +PlugInstall +UpdateRemotePlugins +sleep1 +qa

printinfo "\n"
printinfo "+ ---------------------------- +"
printinfo "| Installing Azure Data Studio |"
printinfo "+ ---------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
. ../shared/userfiles/install-ads.sh

printinfo "\n"
printinfo "+ ------------------------ +"
printinfo "| Installing MongoDB Tools |"
printinfo "+ ------------------------ +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
bash ../shared/userfiles/install-mongodb.sh --tools
bash ../shared/userfiles/install-mongodb.sh --compass

printinfo "\n"
printinfo "+ ------------------------------- +"
printinfo "| Installing MSSQL ODBC and Tools |"
printinfo "+ ------------------------------- +"
[ "$bt_stepping" ] && { yesno "Continue?" || exit 1; }
pushd ../pkgs/mssql-odbc
makepkg -sirc --noconfirm --needed
popd
pushd ../pkgs/mssql-tools
makepkg -sirc --noconfirm --needed
popd


popd > /dev/null
