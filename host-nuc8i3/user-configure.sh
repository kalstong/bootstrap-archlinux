#!/bin/bash

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_path" > /dev/null

. ../misc.sh

XDG_CONFIG_HOME="$HOME/.config"
mkdir -p \
	"${HOME}/.local/bin" \
	"${HOME}/.local/share/applications" \
	"${HOME}/.gnupg/" \
	"${XDG_CONFIG_HOME}/fish" \
	"${XDG_CONFIG_HOME}/git" \
	"${XDG_CONFIG_HOME}/htop" \
	"${XDG_CONFIG_HOME}/nnn/plugins" \
	"${XDG_CONFIG_HOME}/nvim"

touch "${HOME}/.hushlogin"
cp userfiles/.bashrc "${HOME}/.bashrc.aux"
cp userfiles/.energypolicy.sh "${XDG_CONFIG_HOME}/"
cp userfiles/.pam_environment "${HOME}/"
cp userfiles/config.fish "${XDG_CONFIG_HOME}/fish/config.aux.fish"
cp ../shared/userfiles/.bash_profile "${HOME}/"
cp ../shared/userfiles/.bashrc "${HOME}/"
cp ../shared/userfiles/.tmux.conf "${HOME}/"
cp ../shared/userfiles/config.fish "${XDG_CONFIG_HOME}/fish/"
cp ../shared/userfiles/git.conf "${XDG_CONFIG_HOME}/git/config"
cp ../shared/userfiles/gpg.conf "${HOME}/.gnupg/"
cp ../shared/userfiles/htoprc "${XDG_CONFIG_HOME}/htop/"
cp ../shared/userfiles/init.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/init.plug.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/init.chords.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/mimeapps.list "${XDG_CONFIG_HOME}/"
cp ../shared/userfiles/ssh.conf "${HOME}/.ssh/config"
cp ../shared/userfiles/terminate-session.sh "${XDG_CONFIG_HOME}/polybar/"
cp ../shared/userfiles/tmux-gitstat.sh "${HOME}/.local/bin/"

cp ../shared/userfiles/nnn-archive "${XDG_CONFIG_HOME}/nnn/plugins/archive"
cp ../shared/userfiles/nnn-fzcd "${XDG_CONFIG_HOME}/nnn/plugins/fzcd"
cp ../shared/userfiles/nnn-fzopen "${XDG_CONFIG_HOME}/nnn/plugins/fzopen"
cp ../shared/userfiles/nnn-pskill "${XDG_CONFIG_HOME}/nnn/plugins/pskill"

chmod u+x "${XDG_CONFIG_HOME}"/nnn/plugins/*

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
