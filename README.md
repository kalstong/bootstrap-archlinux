## Packages Maintenance

Some packages need manual intervention to check for updates:
- For Azure Data Studio see [here](https://github.com/microsoft/azuredatastudio/releases).
- For Brave see [here](https://github.com/brave/brave-browser/blob/master/CHANGELOG_DESKTOP.md).
- For Firefox ESR see [here](https://www.mozilla.org/firefox/organizations/notes/).
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
