export EDITOR="nvim"
export HOST="black"
export MOUNT="/mnt/media"
export AUR="$HOME/aur"
export CACHE="$HOME/.cache"
export CODE="$HOME/code"
export DOWNLOADS="$HOME/files/downloads"
export FILES="$HOME/files"
export TRASH="$HOME/trash"
export WORK="$HOME/work"

export ASDF_DATA_DIR="$CACHE/asdf"
export GOBIN="$HOME/.local/bin/go"
export GOCACHE="$CACHE/go/build"
export GOMODCACHE="$CACHE/go/lib/pkg/mod"
export GOPATH="$CACHE/go/lib"
export GOROOT="$CACHE/go/bin"
export JAI_DIR="$CACHE/jai"
export LF_BOOKMARKS_PATH="$XDG_CONFIG_HOME/lf/bookmarks"
export NOTES="$FILES/notes"
export NPM_CONFIG_CACHE="$CACHE/npm"
export RECORDINGS="$FILES/recordings"
export SCREENSHOTS="$FILES/screenshots"
export WALLPAPERS="$FILES/wallpapers"
export YARN_CACHE_FOLDER="$CACHE/yarn"

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"
[[ ! "$PATH" =~ "$GOPATH/bin" ]] && export PATH="$PATH:$GOPATH/bin"
[[ ! "$PATH" =~ "$JAI_DIR" ]] && export PATH="$PATH:${JAI_DIR}/bin"

display-layout () {
	[ -z $1 ] && return

	local layout=""
	local layout_file="$XDG_CONFIG_HOME/display_layout"
	local layout_new="$1"
	[ -f "$layout_file" ] && layout=$(cat "$layout_file")

	[ "$layout" != "$layout_new" ] &&
		echo "$layout_new" > "$layout_file" &&
		openbox --reconfigure
}