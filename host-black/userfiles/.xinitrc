# vim:ft=sh

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

[ -f "/etc/X11/xinit/xinitrc.d/50-systemd-user.sh" ] &&
	. "/etc/X11/xinit/xinitrc.d/50-systemd-user.sh"

[ ! -d "$HOME/.cache/wal" ] && wal --theme base16-default
xrdb -merge "$HOME/.Xresources"
xrdb -merge "$HOME/.cache/wal/colors.Xresources"
xsetroot -cursor_name left_ptr

# exec bspwm -c "$XDG_CONFIG_HOME/bspwm/bspwmrc"
exec openbox