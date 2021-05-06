# Collection of my dotfiles and scripts

## Neovim / Vim

The [README.md](./.config/nvim/README.md) and configuration can be found in the [nvim-config folder](./.config/nvim).


## Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


## Used software

Following programs are installed:
* [kitty](https://github.com/kovidgoyal/kitty) _with_ [fira code](https://github.com/tonsky/FiraCode), [starship](https://github.com/starship/starship)
* [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) _with_ [antigen](https://github.com/zsh-users/antigen)
* [neovim](https://github.com/neovim/neovim) _with_ [vim-plug](https://github.com/junegunn/vim-plug), [xclip](https://wiki.ubuntuusers.de/xclip/)
* [lazygit](https://github.com/jesseduffield/lazygit) _with_ [delta](https://github.com/dandavison/delta)
* [tldr](https://github.com/tldr-pages/tldr), [fzf](https://github.com/junegunn/fzf), [ag](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), [jq](https://github.com/stedolan/jq), [fnm](https://github.com/Schniz/fnm)


### On fresh install

Following commands/configs should be run/set on a fresh install:
* install ["used software"](#used-software)
  * install [a patched nerdfont](https://github.com/ryanoasis/nerd-fonts#linux) for icons
  * install antigen in `~/.antigen/antigen.zsh` (mentioned in `.zshrc`)
  * install neovim v0.5+
    * follow the instructions in [nvim-config](./.config/nvim/README.md)
  * install vscode and the plugins
    * follow the instructions in [vscode](./.config/Code/User/README.md)
* for easier editing of the files, create symlinks for the files/folders (then only edit in the git repo)
  * this can be done with the [./setup.sh](./setup.sh) script, which will add symlinks to the dotfiles
* bind capslock to escape
  * ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."
