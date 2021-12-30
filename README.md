# Collection of my dotfiles and scripts

This repository includes all of my public _**scripts**_ and _**configurations**_ of different parts.
The structure represents the home directory to allow easy symlinks.

Bigger parts have their own README and can be found here:
- [Neovim / Vim](./.config/nvim)
- [Custom scripts](./custom-scripts)
- [Visual Studio Code](./.config/Code/User)
- [Ansible](./ansible)
- [Gists](https://gist.github.com/eckon)


## Install

### With ansible

This allows for a quick installation of everything in my configuration.
- install `git` and `ansible`
- clone this respository
- run the [bootstrap.sh](./ansible/bootstrap.sh) script (e.g. `$ ./ansible/boostrap.sh`)
  - this will install the different parts for a quick setup (terminal, tools, symlinks, configs, etc.)
  - see the [ansible part](./ansible) for more information


### Without ansible

- symlink files (configs, scripts)
- install packages/fonts/tools/etc.
- _and/or copy parts of the configuration_


### Optional

- bind capslock to escape (for vim)
  - ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."


## System Structure

- `~` and `~/.config/`
  - includes the "real" configurations
- `~/Development/dotfiles/`
  - has this project inside, acts as a central configuration place
- `~/Development/personal/`
  - has my personal projects
- `~/Development/work/`
  - has work related projects
  - uses a pre-configured [.gitconfig](./.config/gitconfig/work)


## Used software

Following programs should be highlighted and are installed/used:
- [ansible](https://github.com/ansible/ansible)
- [kitty](https://github.com/kovidgoyal/kitty) _with_ [fira code](https://github.com/tonsky/FiraCode), [starship](https://github.com/starship/starship)
- [fish](https://github.com/fish-shell/fish-shell) _with_ [tmux](https://github.com/tmux/tmux)
- [neovim](https://github.com/neovim/neovim) _with_ [vim-plug](https://github.com/junegunn/vim-plug), [xclip](https://wiki.ubuntuusers.de/xclip/)
- [lazygit](https://github.com/jesseduffield/lazygit) _with_ [delta](https://github.com/dandavison/delta)
- [zoxide (z)](https://github.com/ajeetdsouza/zoxide), [tldr](https://github.com/tldr-pages/tldr), [fzf](https://github.com/junegunn/fzf), [ag](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), [jq](https://github.com/stedolan/jq), [fnm](https://github.com/Schniz/fnm)
