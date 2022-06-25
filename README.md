## Packages Maintenance

Some packages need manual intervention to check for updates:
- For Azure Data Studio see [here](https://github.com/microsoft/azuredatastudio/releases).
- For Brave see [here](https://github.com/brave/brave-browser/blob/master/CHANGELOG_DESKTOP.md)
- For Chromium see [here](https://chromiumdash.appspot.com/releases?platform=Linux).
- For Dart Version Manager see [here](https://github.com/cbracken/dvm/tags).
- For Firefox ESR see [here](https://www.mozilla.org/firefox/organizations/notes/).
- For Flutter Version Manager see [here](https://github.com/fluttertools/fvm/releases).
- For Go Version Manager see [here](https://github.com/stefanmaric/g).
- For Forgit see [here](https://github.com/wfxr/forgit).
- For Hosts see [here](https://github.com/stevenblack/hosts).
- For MongoDB Compass see [here](https://www.mongodb.com/try/download/compass).
- For msodbcsql and mssql-tools see [here](https://packages.microsoft.com/rhel/8/prod/).
- For Nerd Fonts see [here](https://github.com/ryanoasis/nerd-fonts/releases).
- For Node.js Version Manager see [here](https://github.com/nvm-sh/nvm/releases).
- For NVFLASH see [here](https://www.techpowerup.com/download/nvidia-nvflash/).

Everything else:
- AUR: `git fetch`, `makepkg -sirc`.
- Fwupd: `fwupdmgr get-devices|refresh|get-updates|update`.
- Golang: `g list-all`, `g install <version>`.
- Node.js/NPM: `nvm ls-remote --lts=fermium`, `nvm install <version>`, `npm outdated -g`.
- Pacman: `sudo pacman -Sy && pacman -Qu`, `sudo pacman -Syu`.
- PiP: `pip list --user --outdated`, `pip install --user --upgrade <pkg>`.
- Vim plugins: `:PlugUgrade`, `:PlugUpdate`, `:UpdateRemotePlugins`, `:COQdeps`.

After the first boot:
1. Set the energy policy: `energypolicy powersave`.
2. Install the SSH keys: `sudo cryptsetup open <device> stash`, `sudo cryptsetup close stash`.
3. Connect to WiFi: `iwctl`.
4. Enable NTP: `timedatectl set-ntp true`.
5. Install NVIM plugins: `:UpdateRemotePlugins`, `:COQdeps`

To create new SSH keys:
- `ssh-keygen -t ed25519 -C <host> -f id_ed25519`.
- `ssh-keygen -t rsa -b 8192 -C <host> -f id_rsa`.
- For files: `chmod u=r,g=,o= id_*`. For folders: `chmod u=rx,g=,o= *`.

## Tasks
- Investigate `broot` as an alternative to `fzf`.
- Investigate `lf` as an alternative to `nnn`.
- Consider replacing `alsa` and `pulseaudio` by [`pipewire`](https://wiki.archlinux.org/title/PipeWire).
- Try to find an alternative to RipGrep that doesn't consumes as much memory,
  retains the necessary functionality and can be integrated w/ neovim/fzf.
- Create a mount point with the partition's label. Check the `--json`
  switch of `lsblk` and use `jq` to parse the output.
- GCC10, GCC11
  * Fix ISL source URL.
  * Remove Ada & Fortran from the build script.
  * Check Arch's GCC12 script for optimizations like PGO, -march=native ...
- GCC10 and GCC11 for ARM T32, A32 and A64. See
  [Instruction Sets](https://developer.arm.com/architectures/instruction-sets)
  for more details about each architecture.
- Improve GPG helper functions to encrypt/decrypt text or binary files.
- Polybar
  * Rewrite all my plugins in C.
  * Do a CPU usage plugin that reads `/proc/stat`.
- Set BIOS undervolt for 9900K, 3950X.
