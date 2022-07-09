## Packages Maintenance

Some packages need manual intervention to check for updates:
- For Azure Data Studio see [here](https://github.com/microsoft/azuredatastudio/releases).
- For Brave see [here](https://github.com/brave/brave-browser/blob/master/CHANGELOG_DESKTOP.md).
- For Bun see [here](https://github.com/Jarred-Sumner/bun/releases).
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

Useful commands:
- See the dependencies of a given package: `pacman -Sii <pkg>`.
- See which installed packages depend on another one: `pacman -Qi <pkg>`.

## Tasks

### High Priority
- Set BIOS undervolt for 9900K, 3950X.
- When mounting a partition, try to use its label to name the mount point.
  Check the `--json` switch of `lsblk` and use `jq` to parse the output.

### Low Priority
- Check [`borg`](https://archlinux.org/packages/community/x86_64/borg/) for compressed/mountable backups.
- Check `broot` as an alternative to `fzf`.
- Check `lf` as an alternative to `nnn`.
- Check [`pipewire`](https://wiki.archlinux.org/title/PipeWire) as an alternative to `alsa` and `pulseaudio`.
- Improve GPG helper functions to encrypt/decrypt text or binary files.
- Polybar: do a CPU usage plugin that reads `/proc/stat`.
- Polybar: rewrite all plugins in C.
- Create PKGBUILDs for GCC10 and GCC11.
  - Check ArchLinux's GCC12 PKGBUILD for optimizations like PGO, -march=native, ...
  - Don't build Ada and Fortran.
  - Fix the URL of ISL.
  - Find out to have GCC build that build/link apps for other
    [instruction sets](https://archlinux.org/packages/community/x86_64/borg/).

### Other
- Consider [obs-glcapture](https://github.com/2xsaiko/obs-glcapture) and
  [obs-vkcapture](https://github.com/nowrep/obs-vkcapture) to record
  OpenGL/Vulkan frame buffers w/ minimal performance penalties.
