# Collection of my dotfiles and scripts


### Neovim / Vim

The [README.md](./.config/nvim/README.md) and configuration can be found in the [nvim-config folder](./.config/nvim).


### Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


### Visual Studio Code

The [README.md](./.config/Code/User/README.md) and configuration can be found in the [code-config folder](./config/Coder/User).


### Ansible

The [README.md](./ansible/README.md), setup and configuration can be found in the [ansible folder](./ansible).


### Gists

Some templates etc. can be found in my [gists](https://gist.github.com/eckon).


## On fresh install _(with ansible)_

* manually install git and ansible
* run the [bootstrap.sh](./ansible/bootstrap.sh) script

Manual configurations and steps:
* bind capslock to escape
  * ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."


## System Structure

* `~` and `~/.config/`
  * includes configurations
* `~/Development/dotfiles/`
  * has this project inside, acts as a central configuration place
* `~/Development/personal/`
  * has my personal projects
* `~/Development/work/`
  * has work related projects
  * uses a pre-configured [.gitconfig](./.config/gitconfig/work)
* `~/.ssh/config`


## Used software

Following programs should be highlighted and are installed/used:
* [ansible](https://github.com/ansible/ansible)
* [kitty](https://github.com/kovidgoyal/kitty) _with_ [fira code](https://github.com/tonsky/FiraCode), [starship](https://github.com/starship/starship)
* [fish](https://github.com/fish-shell/fish-shell) _with_ [tmux](https://github.com/tmux/tmux)
* [neovim](https://github.com/neovim/neovim) _with_ [vim-plug](https://github.com/junegunn/vim-plug), [xclip](https://wiki.ubuntuusers.de/xclip/)
* [lazygit](https://github.com/jesseduffield/lazygit) _with_ [delta](https://github.com/dandavison/delta)
* [zoxide (z)](https://github.com/ajeetdsouza/zoxide), [tldr](https://github.com/tldr-pages/tldr), [fzf](https://github.com/junegunn/fzf), [ag](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), [jq](https://github.com/stedolan/jq), [fnm](https://github.com/Schniz/fnm)
