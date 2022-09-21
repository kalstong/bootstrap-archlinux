export D1="/mnt/d1"
export EDITOR="nvim"
export HOST="nuc8i3"
export MOUNT="/mnt/media"
export AUR="$HOME/aur"
export CACHE="$HOME/.cache"
export DOWNLOADS="$HOME/files/downloads"
export FILES="$HOME/files"
export NOTES="$FILES/notes"
export TRASH="$HOME/trash"


export NNN_BMS="0://;1:$D1;a:$AUR;d:$DOWNLOADS;f:$FILES;m:$MOUNT;n:$NOTES;t:$TRASH"
[[ ! "$PATH" =~ $HOME/.local/bin ]] && export PATH="$PATH:$HOME/.local/bin"
