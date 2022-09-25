## Packages Maintenance

Package Managers:
- ASDF: `asdf latest <pkg> <ver>`, `asdf plugin-update <pkg> <ver>`.
- AUR: `git fetch|pull`, `makepkg -sirc`.
- Fwupd: `fwupdmgr get-devices|refresh|get-updates|update`.
- Node.js/NPM: `npm outdated -g`, `npm update -g <pkg>`.
- Pacman: `sudo pacman -Sy && pacman -Qu`, `sudo pacman -Syu`.
- Python/pip: `pip list --user --outdated`, `pip install --user --upgrade <pkg>`.
- Vim plugins: `:PlugUpgrade`, `:PlugUpdate`, `:UpdateRemotePlugins`.

Some packages have their own install scripts and must be manually updated:
- For Azure Data Studio see [here](https://github.com/microsoft/azuredatastudio/releases).
- For Hosts see [here](https://github.com/stevenblack/hosts).
- For JAI see release emails from Jonathan Blow.
- For MongoDB Compass see [here](https://www.mongodb.com/try/download/compass).
- For MSSQL ODBC and Tools see [here](https://packages.microsoft.com/rhel/8/prod/).
- For Nerd Fonts see [here](https://github.com/ryanoasis/nerd-fonts/releases).
- For NVFLASH see [here](https://www.techpowerup.com/download/nvidia-nvflash/).

After the first boot:
1. Set the energy policy: `energypolicy powersave`.
2. Install the SSH keys: `sudo cryptsetup open <device> stash`, `sudo cryptsetup close stash`.
3. Connect to WiFi: `iwctl`.
4. Enable NTP: `timedatectl set-ntp true`.

To create new SSH keys:
- `ssh-keygen -t ed25519 -C <host> -f id_ed25519`.
- `ssh-keygen -t rsa -b 8192 -C <host> -f id_rsa`.
- For files: `chmod u=r,g=,o= id_*`. For folders: `chmod u=rx,g=,o= *`.

Useful commands:
- See the dependencies of a given package: `pacman -Sii <pkg>`.
- See which installed packages depend on another one: `pacman -Qi <pkg>`.

Useful packages not installed by default:
- Development: hey, perf, strace, sysbench, systat, tokei, valgrind.
- System: arch-audit, bind, ctop, lfs, turbostat, usbutils.
- Utils: archiso, croc, edk2-ovmf, entr, pdfgrep, qemu-full,
  qemu-emulators-full, mosh, tree, woeusb-ng@master.


## Tasks

### High Priority
- Create a shell function simplify miniserve setup.
- Set BIOS undervolt for 9900K, 3950X.
- When mounting a partition, try to use its label to name the mount point.
  Check the `--json` switch of `lsblk` and use `jq` to parse the output.
- Customize [vim-visual-multi](https://github.com/mg979/vim-visual-multi/wiki).
- Consider moving the boot partition back to an external USB disk and
  find out how to encrypt the internal disks based on TPM.

### Low Priority
- Check [`borg`](https://archlinux.org/packages/community/x86_64/borg/)
  for compressed/mountable backups.
- Check [`broot`](https://github.com/Canop/broot) as an alternative to `fzf`
  for file system navigation.
- Check [`clp`](https://github.com/jpe90/clp) as an alternative to `bat`.
- Check [`fzy`](https://github.com/jhawthorn/fzy) as an alternative to `fzf`,
  when the input doesn't change.
- Check [`pipewire`](https://wiki.archlinux.org/title/PipeWire) as an
  alternative to `alsa` and `pulseaudio`.
- Improve GPG helper functions to encrypt/decrypt text or binary files.
- Create PKGBUILDs for GCC10 and GCC11.
  - Check ArchLinux's GCC12 PKGBUILD for optimizations like PGO, -march=native, ...
  - Don't build Ada and Fortran.
  - Fix the URL of ISL.
  - Find out to have GCC build that build/link apps for other
    [instruction sets](https://archlinux.org/packages/community/x86_64/borg/).
- Consider installing [yt-dlp](https://archlinux.org/packages/community/any/yt-dlp/)
  It integrates with MPV allowing it to play media from Twitter, YouTube, etc ...

### Other
- Consider [obs-glcapture](https://github.com/2xsaiko/obs-glcapture) and
  [obs-vkcapture](https://github.com/nowrep/obs-vkcapture) to record
  OpenGL/Vulkan frame buffers w/ minimal performance penalties.


## Overclock/Undervolt Configuration
- nuc8i3: Controlled through `intel-undervolt`
- nuc8i7: Controlled through `intel-undervolt`
- nuc8hvk: TODO
- 8700k: TODO
- 9900k: TODO
- 3950x: TODO


## Notes
- List of [Chromium's CLI switches](https://peter.sh/experiments/chromium-command-line-switches/).
