export EDITOR="nvim"
export HOST="nuc8i3"
export MOUNT="/mnt/media"
export AUR="$HOME/aur"
export CACHE="$HOME/.cache"
export CODE="$HOME/code"
export FILES="$HOME/files"
export TRASH="$HOME/trash"
export WORK="$HOME/work"

export DOWNLOADS="$FILES/downloads"
export GOBIN="$HOME/.local/bin/go"
export GOCACHE="$CACHE/go/build"
export GOMODCACHE="$CACHE/go/lib/pkg/mod"
export GOPATH="$CACHE/go/lib"
export GOROOT="$CACHE/go/bin"
export NOTES="$FILES/notes"
export NPM_CONFIG_CACHE="$CACHE/npm"
export NVM_DIR="$CACHE/nvm"
export RECORDINGS="$FILES/recordings"
export SCREENSHOTS="$FILES/screenshots"
export WALLPAPERS="$FILES/wallpapers"
export YARN_CACHE_FOLDER="$CACHE/yarn"

export NNN_BMS="0://;a:$AUR;c:$CODE;d:$DOWNLOADS;f:$FILES;m:$MOUNT;n:$NOTES;r:$RECORDINGS;s:$SCREENSHOTS;t:$TRASH;w:$WORK"
[[ ! "$PATH" =~ $HOME/.local/bin ]] && export PATH="$PATH:$HOME/.local/bin"
[[ ! "$PATH" =~ $GOPATH/bin ]] && export PATH="$PATH:$GOPATH/bin"

display_layout () {
	[ -z $1 ] && return

	local layout=""
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	local layout_new="$1"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")

	[ "$layout" != "$layout_new" ] &&
		echo "$layout_new" > "$layout_file" &&
		bspc wm --restart
}