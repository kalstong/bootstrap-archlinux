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
- Set the energy policy: `energypolicy powersave`.
- Install the SSH keys: `sudo cryptsetup open <dev> <name>`, `sudo cryptsetup close <name>`.
- Connect to WiFi: `iwctl`.
- Enable NTP: `timedatectl set-ntp true`.

To create new SSH keys:
- `ssh-keygen -t ed25519 -C <host> -f id_ed25519`
- `ssh-keygen -t rsa -b 8191 -C <host> -f id_rsa`
- `chmod u=r,g=,o= id_*`

## Tasks
- Reenable zoomed flag in tmux.
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
