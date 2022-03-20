## Packages Maintenance

Some packages need manual intervention to check for updates:
- For Azure Data Studio see [here](https://github.com/microsoft/azuredatastudio/releases).
- For Brave see [here](https://github.com/brave/brave-browser/blob/master/CHANGELOG_DESKTOP.md)
- For Firefox ESR see [here](https://www.mozilla.org/firefox/organizations/notes/)
- For Go version manager (g) see [here](https://github.com/stefanmaric/g).
- For MongoDB Compass see [here](https://www.mongodb.com/try/download/compass).
- For Nerd Fonts see [here](https://github.com/ryanoasis/nerd-fonts/releases).
- For Node.js version manage (NVM) see [here](https://github.com/nvm-sh/nvm/releases).

Everything else:
- AUR: `git fetch`, `makepkg -sirc`.
- Golang: `g list-all`, `g install <version>`.
- Node.js/NPM: `nvm ls-remote --lts=fermium`, `nvm install <pkg_version>`.
- Pacman: `sudo pacman -Sy && pacman -Qu`, `sudo pacman -Syu`.
- PiP: `pip list --user --outdated`, `pip install --user --upgrade <pkg>`.
- Vim plugins: `:PlugUpdate`, `:PlugUpgrade`, `:COQdeps`, `:TSUpdate`, `:UpdateRemotePlugins`.

## TODO - Hosts
- up: Use macBook to share the internet connection for te setup.
- hvk: Re-target for UHD.
- 8700k: Review previous config.

## TODO - Other
- Improve gpg helper functions to encrypt/decrypt text files using vim.
- Improve gpg helper functions to encrypt/decrypt non-text files.
- Remove ADA and Fortran from GCC 8/9/10 builds.
- `mnt` should try to create a mount point with the label of the partition
  when it is available. Check the `--json` switch of `lsblk` and consider
  using `jq` to parse the output.
- Rewrite all polybar plugins in C.
- Parse `/proc/stat` to compute the CPU usage.
- Review mouse polling rate and acceleration. Maybe its time to give
  the Bluetooth mouse another try.  
  https://wiki.archlinux.org/title/Mouse_polling_rate  
  https://wiki.archlinux.org/title/Razer_peripherals
- Relegate undervolting to the BIOS whenever possible: nu8i7-hvk, 8700k, 9900k, 3950x
- Check https://peter.sh/experiments/chromium-command-line-switches/ and
  https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration for the
  optimal settings for GPU rendering and Hardware Video Decoding.
  In particular see `--use-gl=???`, `--use-angle=???` and `--use-vulkan`.
