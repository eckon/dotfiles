# Collection of my dotfiles and scripts

This repository includes all of my public _**scripts**_ and _**configurations**_ of different parts.
The structure represents the home directory to allow easy symlinks.

Bigger parts have their own README and can be found here:
- [Neovim](./config/nvim)
- [Scripts](./scripts)
- [Visual Studio Code](./config/Code/User)
- [Gists](https://gist.github.com/eckon)


## Install

Installation of everything in my configuration:
- install `git`
- clone this repository
- run `make`
  - this will install the different parts for a quick setup (terminal, tools, symlinks, configs, etc.)


## System Structure

- `~` and `~/.config/`
  - includes the "real" configurations
- `~/Development/dotfiles/`
  - has this project inside, acts as a central configuration place
- `~/Development/personal/`
  - has my personal projects
- `~/Development/work/`
  - has work related projects
  - uses a pre-configured [.gitconfig](./config/git/work)


## Used software

Following programs should be highlighted and are installed/used:
- [kitty](https://github.com/kovidgoyal/kitty) _with_ [fira code](https://github.com/tonsky/FiraCode), [starship](https://github.com/starship/starship)
- [fish](https://github.com/fish-shell/fish-shell) _with_ [tmux](https://github.com/tmux/tmux)
- [neovim](https://github.com/neovim/neovim) _with_ [packer](https://github.com/wbthomason/packer.nvim), [xclip](https://wiki.ubuntuusers.de/xclip/)
- [lazygit](https://github.com/jesseduffield/lazygit) _with_ [delta](https://github.com/dandavison/delta)
- [zoxide (z)](https://github.com/ajeetdsouza/zoxide), [tldr](https://github.com/tldr-pages/tldr), [fzf](https://github.com/junegunn/fzf), [ag](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), [jq](https://github.com/stedolan/jq), [fnm](https://github.com/Schniz/fnm)
