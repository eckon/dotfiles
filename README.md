# Collection of my dotfiles and scripts


### Neovim / Vim

The [README.md](./.config/nvim/README.md) and configuration can be found in the [nvim-config folder](./.config/nvim).


### Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


### Visual Studio Code

The [README.md](./.config/Code/User/README.md) and configuration can be found in the [code-config folder](./config/Coder/User).


### Ansible

The [README.md](./ansible/README.md), setup and configuration can be found in the [ansible folder](./ansible).


## On fresh install _(with ansible)_

* manually install git and ansible
* run the [bootstrap.sh](./ansible/bootstrap.sh) script

Manual configurations and steps:
* change shell to fish `chsh -s /usr/bin/fish`
* use fnm to install node `fnm use <node-version>`
* kitty is installed under `~/.local/kitty.app`
  * .desktop files and setting it to the default still needs to be done manually
  * this [link](https://sw.kovidgoyal.net/kitty/binary.html#desktop-integration-on-linux) might help
* bind capslock to escape
  * ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."


## Used software

Following programs should be highlighted and are installed/used:
* [ansible](https://github.com/ansible/ansible)
* [kitty](https://github.com/kovidgoyal/kitty) _with_ [fira code](https://github.com/tonsky/FiraCode), [starship](https://github.com/starship/starship)
* [fish](https://github.com/fish-shell/fish-shell)
* [neovim](https://github.com/neovim/neovim) _with_ [vim-plug](https://github.com/junegunn/vim-plug), [xclip](https://wiki.ubuntuusers.de/xclip/)
* [lazygit](https://github.com/jesseduffield/lazygit) _with_ [delta](https://github.com/dandavison/delta)
* [zoxide (z)](https://github.com/ajeetdsouza/zoxide), [tldr](https://github.com/tldr-pages/tldr), [fzf](https://github.com/junegunn/fzf), [ag](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat), [jq](https://github.com/stedolan/jq), [fnm](https://github.com/Schniz/fnm)
