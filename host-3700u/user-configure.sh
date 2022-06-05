#!/bin/bash

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$script_path" > /dev/null

. ../misc.sh

XDG_CONFIG_HOME="$HOME/.config"
mkdir -p \
	"${HOME}/.icons" \
	"${HOME}/.local/bin" \
	"${HOME}/.local/share/applications" \
	"${HOME}/.local/share/dunst" \
	"${HOME}/.local/share/polybar" \
	"${HOME}/.local/share/picom" \
	"${HOME}/.local/share/tint2" \
	"${HOME}/.gnupg/" \
	"${XDG_CONFIG_HOME}/alacritty" \
	"${XDG_CONFIG_HOME}/bspwm" \
	"${XDG_CONFIG_HOME}/btop" \
	"${XDG_CONFIG_HOME}/ctags" \
	"${XDG_CONFIG_HOME}/dunst" \
	"${XDG_CONFIG_HOME}/fish" \
	"${XDG_CONFIG_HOME}/flashfocus" \
	"${XDG_CONFIG_HOME}/fontconfig" \
	"${XDG_CONFIG_HOME}/git" \
	"${XDG_CONFIG_HOME}/gtk-3.0" \
	"${XDG_CONFIG_HOME}/htop" \
	"${XDG_CONFIG_HOME}/lf" \
	"${XDG_CONFIG_HOME}/mpv" \
	"${XDG_CONFIG_HOME}/nnn/plugins" \
	"${XDG_CONFIG_HOME}/nvim" \
	"${XDG_CONFIG_HOME}/polybar" \
	"${XDG_CONFIG_HOME}/pulse" \
	"${XDG_CONFIG_HOME}/rofi/themes" \
	"${XDG_CONFIG_HOME}/sxhkd" \
	"${XDG_CONFIG_HOME}/tint2"

_monospace_font="monospace"
_monospace_font_size="9.5"
_terminal_font_size="9.5"

touch "${HOME}/.hushlogin"
cp userfiles/.bashrc "${HOME}/.bashrc.aux"
cp userfiles/.energypolicy.sh "${XDG_CONFIG_HOME}/"
cp userfiles/.pam_environment "${HOME}/"
cp userfiles/bspwm.sh "${XDG_CONFIG_HOME}/bspwm/"
cp userfiles/config.fish "${XDG_CONFIG_HOME}/fish/config.aux.fish"
cp userfiles/display_layout.sh "${XDG_CONFIG_HOME}/"
cp userfiles/polybar.ini "${XDG_CONFIG_HOME}/polybar/config.ini"
cp userfiles/tint2rc "${XDG_CONFIG_HOME}/tint2/"
cp ../shared/userfiles/.bash_profile "${HOME}/"
cp ../shared/userfiles/.bashrc "${HOME}/"
cp ../shared/userfiles/.ctags "${XDG_CONFIG_HOME}/ctags/default.ctags"
cp ../shared/userfiles/.tmux.conf "${HOME}/"
cp ../shared/userfiles/.xinitrc "${HOME}/"
cp ../shared/userfiles/.Xresources "${HOME}/"
cp ../shared/userfiles/alacritty-theme.sh "${HOME}/.local/bin/"
cp ../shared/userfiles/brave-flags.conf "${XDG_CONFIG_HOME}/"
cp ../shared/userfiles/bspwmrc "${XDG_CONFIG_HOME}/bspwm/"
cp ../shared/userfiles/btop.conf "${XDG_CONFIG_HOME}/btop/"
cp ../shared/userfiles/config.fish "${XDG_CONFIG_HOME}/fish/"
cp ../shared/userfiles/chromium-flags.conf "${XDG_CONFIG_HOME}/"
cp ../shared/userfiles/dunstrc "${XDG_CONFIG_HOME}/dunst/"
cp ../shared/userfiles/feh-preview.desktop "${HOME}/.local/share/applications"
cp ../shared/userfiles/flashfocus.yml "${XDG_CONFIG_HOME}/flashfocus"
cp ../shared/userfiles/fonts.conf "${XDG_CONFIG_HOME}/fontconfig/"
cp ../shared/userfiles/git.conf "${XDG_CONFIG_HOME}/git/config"
cp ../shared/userfiles/gpg.conf "${HOME}/.gnupg/"
cp ../shared/userfiles/gtk3.ini "${XDG_CONFIG_HOME}/gtk-3.0/settings.ini"
cp ../shared/userfiles/htoprc "${XDG_CONFIG_HOME}/htop/"
cp ../shared/userfiles/lfrc "${XDG_CONFIG_HOME}/lf/"
cp ../shared/userfiles/init.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/init.plug.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/init.chords.vim "${XDG_CONFIG_HOME}/nvim/"
cp ../shared/userfiles/mimeapps.list "${XDG_CONFIG_HOME}/"
cp ../shared/userfiles/mpv.conf "${XDG_CONFIG_HOME}/mpv/"
cp ../shared/userfiles/postman.desktop "${HOME}/.local/share/applications"
cp ../shared/userfiles/redshift.conf "${XDG_CONFIG_HOME}/"
cp ../shared/userfiles/rofi_1440p.rasi "${XDG_CONFIG_HOME}/rofi/themes"
cp ../shared/userfiles/signal-desktop.desktop "${HOME}/.local/share/applications/"
cp ../shared/userfiles/spotify.desktop "${HOME}/.local/share/applications/"
cp ../shared/userfiles/spotify.png "${HOME}/.icons/"
cp ../shared/userfiles/ssh.conf "${HOME}/.ssh/config"
cp ../shared/userfiles/start-spotify.sh "${HOME}/.local/bin/"
cp ../shared/userfiles/start-teams.sh "${HOME}/.local/bin/"
cp ../shared/userfiles/sxhkdrc "${XDG_CONFIG_HOME}/sxhkd/"
cp ../shared/userfiles/teams.desktop "${HOME}/.local/share/applications/"
cp ../shared/userfiles/teams.png "${HOME}/.icons/"
cp ../shared/userfiles/terminate-session.sh "${XDG_CONFIG_HOME}/polybar/"
cp ../shared/userfiles/tmux-gitstat.sh "${HOME}/.local/bin/"
sed -i -r "s|<dir>|${TRASH}/.firejail.postman|" "${HOME}/.local/share/applications/postman.desktop"

cp ../shared/userfiles/nnn-archive "${XDG_CONFIG_HOME}/nnn/plugins/archive"
cp ../shared/userfiles/nnn-fzcd "${XDG_CONFIG_HOME}/nnn/plugins/fzcd"
cp ../shared/userfiles/nnn-fzopen "${XDG_CONFIG_HOME}/nnn/plugins/fzopen"
cp ../shared/userfiles/nnn-pskill "${XDG_CONFIG_HOME}/nnn/plugins/pskill"
cp ../shared/userfiles/polybar-*.sh "${HOME}/.local/bin/"
gcc ../shared/userfiles/polybar-polytimer.c \
	-Wall -Wextra -O2 -march=native \
	-o "${HOME}/.local/bin/polytimer"

chmod u+x "${XDG_CONFIG_HOME}/bspwm/bspwmrc"
chmod u+x "${XDG_CONFIG_HOME}/display_layout.sh"
chmod u+x "${XDG_CONFIG_HOME}"/nnn/plugins/*
chmod u+x "${HOME}/.local/bin/start-spotify.sh"
chmod u+x "${HOME}/.local/bin/start-teams.sh"
chmod u+x "${HOME}/.local/bin/tmux-gitstat.sh"

cp ../shared/userfiles/alacritty.yml /tmp
sed -i -r "s|<monospace-font-size>|${_monospace_font_size}|" /tmp/alacritty.yml
sed -i -r "s|<terminal-font-size>|${_terminal_font_size}|" /tmp/alacritty.yml
mv /tmp/alacritty.yml "${XDG_CONFIG_HOME}/alacritty/alacritty.yml"

sed -i -r "s|<xdg-config-home>|${XDG_CONFIG_HOME}|" "${HOME}/.pam_environment"
xdg-user-dirs-update --force &> /dev/null
xdg-user-dirs-update --set DESKTOP "$HOME"
xdg-user-dirs-update --set DOCUMENTS "$FILES"
xdg-user-dirs-update --set DOWNLOAD "$DOWNLOADS"
rmdir "$HOME/"{Desktop,Documents,Downloads,Music} &> /dev/null
rmdir "$HOME/"{Pictures,Public,Templates,Videos} &> /dev/null

sed -i -r "s|<monospace-font-size>|${_monospace_font_size}|" "${HOME}/.Xresources"
sed -i -r "s|<monospace-font-size>|${_monospace_font} ${_monospace_font_size}|" "${XDG_CONFIG_HOME}/dunst/dunstrc"
sed -i -r "s|<monospace-font-size>|${_monospace_font_size}|" "${XDG_CONFIG_HOME}/polybar/config.ini"

cp ../shared/userfiles/picom.conf /tmp
sed -i -r "s|<username>|$USER|" "/tmp/picom.conf"
sed -i -r "s|<backend>|glx|" "/tmp/picom.conf"
sed -i -r "s|<enable-vsync>|false|" "/tmp/picom.conf"
sed -i -r "s|<enable-sync-fence>|false|" "/tmp/picom.conf"
cp /tmp/picom.conf "${XDG_CONFIG_HOME}/"

if [ -f "$HOME/.cache/wal/colors.sh" ]; then
	. "$HOME/.cache/wal/colors.sh"
	sed -i -r "s/<urgency-low-bg>/$background/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-low-fg>/$foreground/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-low-frame>/$foreground/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-normal-bg>/$background/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-normal-fg>/$foreground/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-normal-frame>/$foreground/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-critical-bg>/$background/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-critical-fg>/$color3/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-critical-frame>/$color3/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
else
	# sensible defaults
	sed -i -r "s/<urgency-low-bg>/#151515/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-low-fg>/#d0d0d0/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-low-frame>/#d0d0d0/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-normal-bg>/#151515/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-normal-fg>/#d0d0d0/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-normal-frame>/#d0d0d0/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-critical-bg>/#151515/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-critical-fg>/#ddb26f/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
	sed -i -r "s/<urgency-critical-frame>/#ddb26f/" "${XDG_CONFIG_HOME}/dunst/dunstrc"
fi

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

_forgit_bash_dir="${HOME}"
_forgit_bash_file=".forgit.plugin.sh"
if [ ! -f "${_forgit_bash_dir}/${_forgit_bash_file}" ]; then
	# Consulted on 2022-05-18
	_forgit_bash_url="https://raw.githubusercontent.com/wfxr/forgit/75e9d12bacaea12012c89facf80bf42a5ad9b769/forgit.plugin.zsh"

	printwarn "Downloading forgit for Bash shell ..."
	curl --connect-timeout 13 --retry 5 --retry-delay 2 \
		"$_forgit_bash_url" -sS -H "Accept:application/vnd.github.v3.raw" \
		-o "${_forgit_bash_dir}/${_forgit_bash_file}"
fi

_forgit_fish_dir="${XDG_CONFIG_HOME}/fish"
_forgit_fish_file="forgit.plugin.fish"
if [ ! -f "${_forgit_fish_dir}/${_forgit_fish_file}" ]; then
	# Consulted on 2022-05-18
	_forgit_fish_url="https://raw.githubusercontent.com/wfxr/forgit/75e9d12bacaea12012c89facf80bf42a5ad9b769/conf.d/forgit.plugin.fish"

	printwarn "Downloading forgit for Fish shell ..."
	curl --connect-timeout 13 --retry 5 --retry-delay 2 \
		"$_forgit_fish_url" -sS -H "Accept:application/vnd.github.v3.raw" \
		-o "${_forgit_fish_dir}/${_forgit_fish_file}"
fi

popd > /dev/null
