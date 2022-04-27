## Packages Maintenance

Some packages need manual intervention to check for updates:
- For Azure Data Studio see [here](https://github.com/microsoft/azuredatastudio/releases).
- For Brave see [here](https://github.com/brave/brave-browser/blob/master/CHANGELOG_DESKTOP.md)
  (for Chromium [here](https://chromiumdash.appspot.com/releases?platform=Linux)).
- For Firefox ESR see [here](https://www.mozilla.org/firefox/organizations/notes/).
- For Go version manager (g) see [here](https://github.com/stefanmaric/g).
- For MongoDB Compass see [here](https://www.mongodb.com/try/download/compass).
- For Nerd Fonts see [here](https://github.com/ryanoasis/nerd-fonts/releases).
- For Node.js version manage (NVM) see [here](https://github.com/nvm-sh/nvm/releases).
- For NVFLASH see [here](https://www.techpowerup.com/download/nvidia-nvflash/).

Everything else:
- AUR: `git fetch`, `makepkg -sirc`.
- Fwupd: `fwupdmgr get-devices`, `fwupdmgr refresh`, `fwupdmgr get-updates`, `fwupdmgr update`.
- Golang: `g list-all`, `g install <version>`.
- Node.js/NPM: `nvm ls-remote --lts=fermium`, `nvm install <pkg_version>`.
- Pacman: `sudo pacman -Sy && pacman -Qu`, `sudo pacman -Syu`.
- PiP: `pip list --user --outdated`, `pip install --user --upgrade <pkg>`.
- Vim plugins: `:PlugUpdate`, `:PlugUpgrade`, `:COQdeps`, `:TSUpdate`, `:UpdateRemotePlugins`.

After the first boot:
1. Set the energy policy: `energypolicy powersave`.
2. Install the SSH keys: `sudo cryptsetup open <dev> <name>`, `sudo cryptsetup close <name>`.
3. Connect to WiFi: `iwctl`.
4. Enable NTP: `timedatectl set-ntp true`.
5. Install NVIM plugins: `:UpdateRemotePlugins`, `:COQdeps`

To create new SSH keys:
- `ssh-keygen -t ed25519 -C <host> -f id_ed25519`.
- `ssh-keygen -t rsa -b 8191 -C <host> -f id_rsa`.
- For files: `chmod u=r,g=,o= id_*`. For folders: `chmod u=rx,g=,o= id_*`.

## Tasks
- Reenable zoomed flag in tmux.
- Set a TDP limit through `energypolicy` for NVIDIA GPUs. See
  [here](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Custom_TDP_Limit).
- Create a mount point with the partition's label. Check the `--json`
  switch of `lsblk` and use `jq` to parse the output.
- GCC9, GCC10
  * Fix ISL source URL.
  * Remove Ada & Fortran from the build script.
  * Check Arch's GCC11 script for optimizations like PGO, -march=native ...
- GCC8, GCC9, GCC10 and GCC11 for ARM T32, A32 and A64. See
  [Instruction Sets](https://developer.arm.com/architectures/instruction-sets)
  for more details about each architecture.
- Improve GPG helper functions to encrypt/decrypt text or binary files.
- Polybar
  * Rewrite all my plugins in C.
  * Do a CPU usage plugin that reads `/proc/stat`.
- Set BIOS undervolt for NUC8i7-HVK, 8700K, 9900K, 3950X.
- Start preparing GCC11 build script based on Arch's.
