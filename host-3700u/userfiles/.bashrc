export EDITOR="nvim"
export HOST="3700u"
export MOUNT="/mnt/media"
export AUR="$HOME/aur"
export CACHE="$HOME/.cache"
export CODE="$HOME/code"
export FILES="$HOME/files"
export TRASH="$HOME/trash"
export WORK="$HOME/work"

export DOWNLOADS="$FILES/downloads"
export DVM_DIR="$CACHE/denovm" # Deno Version Manager
export DVM_ROOT="$CACHE/dvm"   # Dart Version Manager
export FVM_HOME="$CACHE/fvm"
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
[[ ! "$PATH" =~ "$DVM_DIR" ]] && export PATH="$PATH:${DVM_DIR}/bin"
[[ ! "$PATH" =~ "$DVM_ROOT/current" ]] &&
	export DART_SDK="${DVM_ROOT}/current" &&
	export PATH="$PATH:${DVM_ROOT}/current/bin"
