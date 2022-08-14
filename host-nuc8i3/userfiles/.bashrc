export EDITOR="nvim"
export HOST="nuc8i3"
export MOUNT="/mnt/media"
export AUR="$HOME/aur"
export CACHE="$HOME/.cache"
export CODE="$HOME/code"
export DOWNLOADS="$HOME/files/downloads"
export FILES="$HOME/files"
export TRASH="$HOME/trash"
export WORK="$HOME/work"


export NNN_BMS="0://;a:$AUR;c:$CODE;d:$DOWNLOADS;f:$FILES;m:$MOUNT;n:$NOTES;r:$RECORDINGS;s:$SCREENSHOTS;t:$TRASH;w:$WORK"
[[ ! "$PATH" =~ $HOME/.local/bin ]] && export PATH="$PATH:$HOME/.local/bin"
