#!/bin/bash

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_path" > /dev/null

. ../misc.sh

if [ "$HOST" != "nuc8i3" ]; then
	printerr "ERROR: This configuration file belongs to nuc8i3."
	exit 1
fi

XDG_CONFIG_HOME="$HOME/.config"
mkdir -p \
	"${HOME}/.local/bin" \
	"${HOME}/.local/share/applications" \
	"${HOME}/.local/share/lf" \
	"${HOME}/.gnupg/" \
	"${XDG_CONFIG_HOME}/fish" \
	"${XDG_CONFIG_HOME}/git" \
	"${XDG_CONFIG_HOME}/htop" \
	"${XDG_CONFIG_HOME}/lf" \
	"${XDG_CONFIG_HOME}/nvim"

touch "${HOME}/.hushlogin"
touch "${XDG_CONFIG_HOME}/lf/bookmarks"
cp userfiles/.bashrc "${HOME}/.bashrc.aux"
cp userfiles/.energypolicy.sh "${XDG_CONFIG_HOME}/"
cp userfiles/.pam_environment "${HOME}/"
cp userfiles/config.fish "${XDG_CONFIG_HOME}/fish/config.aux.fish"
cp ../shared/userfiles/.bash_profile "${HOME}/"
cp ../shared/userfiles/.bashrc "${HOME}/"
cp ../shared/userfiles/.tmux.conf "${HOME}/"
cp ../shared/userfiles/config.fish "${XDG_CONFIG_HOME}/fish/"
cp ../shared/userfiles/cp-p "${HOME}/.local/bin/"
cp ../shared/userfiles/git.conf "${XDG_CONFIG_HOME}/git/config"
cp ../shared/userfiles/gpg.conf "${HOME}/.gnupg/"
cp ../shared/userfiles/htoprc "${XDG_CONFIG_HOME}/htop/"
cp ../shared/userfiles/lfrc "${XDG_CONFIG_HOME}/lf/"
cp ../shared/userfiles/lficons "${XDG_CONFIG_HOME}/lf/icons"
cp ../shared/userfiles/lfpreview "${HOME}/.local/bin/"
cp ../shared/userfiles/init.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/init.plug-slim.vim "${XDG_CONFIG_HOME}/nvim/init.plug.vim"
cp ../shared/userfiles/init.chords.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/mimeapps.list "${XDG_CONFIG_HOME}/"
cp ../shared/userfiles/mv-p "${HOME}/.local/bin/"
cp ../shared/userfiles/ssh.conf "${HOME}/.ssh/config"
cp ../shared/userfiles/terminate-session.sh "${HOME}/.local/bin/"
cp ../shared/userfiles/tmux-gitstat.sh "${HOME}/.local/bin/"

echo "0:/
a:${AUR}
d:${DOWNLOADS}
f:${FILES}
h:${HOME}
m:${MOUNT}
t:${TRASH}" > "${HOME}/.local/share/lf/marks"

chmod u+x "${HOME}/.local/bin/cp-p"
chmod u+x "${HOME}/.local/bin/lfpreview"
chmod u+x "${HOME}/.local/bin/mv-p"

sed -i -r "s|<xdg-config-home>|${XDG_CONFIG_HOME}|" "${HOME}/.pam_environment"
xdg-user-dirs-update --force &> /dev/null
xdg-user-dirs-update --set DESKTOP "$HOME"
xdg-user-dirs-update --set DOCUMENTS "$FILES"
xdg-user-dirs-update --set DOWNLOAD "$DOWNLOADS"
rmdir "$HOME/"{Desktop,Documents,Downloads,Music} &> /dev/null
rmdir "$HOME/"{Pictures,Public,Templates,Videos} &> /dev/null

rm -f "$HOME/.ssh/authorized_keys"
for f in ../ssh/*.pub; do cat "$f" >> "$HOME/.ssh/authorized_keys"; done
chmod u=r,g=r,o= "$HOME/.ssh/authorized_keys"

_vimplug_dir="${HOME}/.local/share/nvim/site/autoload"
if [ ! -f "${_vimplug_dir}/plug.vim" ]; then
	_vimplug_url="https://api.github.com/repos/junegunn/vim-plug/contents/plug.vim"
	printwarn "Downloading '$_vimplug_url' ..."
	mkdir -p "$_vimplug_dir"
	curl --connect-timeout 13 --retry 5 --retry-delay 2 \
		"$_vimplug_url" -sS -H "Accept:application/vnd.github.v3.raw" -o "${_vimplug_dir}/plug.vim"
fi

popd > /dev/null
