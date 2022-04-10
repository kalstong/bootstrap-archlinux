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

Everything else:
- AUR: `git fetch`, `makepkg -sirc`.
- Fwupd: `fwupdmgr get-devices`, `fwupdmgr refresh`, `fwupdmgr get-updates`, `fwupdmgr update`.
- Golang: `g list-all`, `g install <version>`.
- Node.js/NPM: `nvm ls-remote --lts=fermium`, `nvm install <pkg_version>`.
- Pacman: `sudo pacman -Sy && pacman -Qu`, `sudo pacman -Syu`.
- PiP: `pip list --user --outdated`, `pip install --user --upgrade <pkg>`.
- Vim plugins: `:PlugUpdate`, `:PlugUpgrade`, `:COQdeps`, `:TSUpdate`, `:UpdateRemotePlugins`.

## Tasks
- Brave: Set up my own PKGBUILD.
- Firefox ESR: Set up my own PKGBUILD.
- GCC8
  * Remove Fortran from the build script.
  * Check Arch's GCC11 script for optimizations like PGO, -march=native ...
- GCC9
  * Remove Fortran from the build script.
  * Check Arch's GCC11 script for optimizations like PGO, -march=native ...
- GCC10
  * Remove Ada and Fortran from the build script.
  * Check Arch's GCC11 script for optimizations like PGO, -march=native ...
- GCC11: Start preparing the build script based on Arch's.
- gpg: Improve helper functions to encrypt/decrypt text or binary files.
- Polybar
  * Rewrite all my plugins in C.
  * Do a CPU usage plugin that reads `/proc/stat`.
- mnt: Create a mount point with the partition's label. Check the `--json`
  switch of `lsblk` and use `jq` to parse the output.
- Undervolt: Do it through BIOS instead of software for  NUC8i7-HVK, 8700K,
  9900K, 3950X.
