# Collection of my dotfiles and scripts

## Neovim / Vim

The [README.md](./.config/nvim/README.md) and configuration can be found in the [nvim-config folder](./.config/nvim).


## Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


## Used software

Following programs are installed:
* [kitty](https://github.com/kovidgoyal/kitty)
  * [fira code](https://github.com/tonsky/FiraCode), [starship](https://github.com/starship/starship)
* [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  * [antigen](https://github.com/zsh-users/antigen)
* [neovim](https://github.com/neovim/neovim)
  * [vim-plug](https://github.com/junegunn/vim-plug), [xclip](https://wiki.ubuntuusers.de/xclip/)
* [lazygit](https://github.com/jesseduffield/lazygit)
  * [delta](https://github.com/dandavison/delta)
* Others
  * [tldr](https://github.com/tldr-pages/tldr), [fzf](https://github.com/junegunn/fzf), [the_silver_searcher (ag)](https://github.com/ggreer/the_silver_searcher), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat)


### On fresh install

Following commands/configs should be run/set on fresh install:
* install "used software"
  * install antigen in `~/.antigen/antigen.zsh` (mentioned in `.zshrc`)
  * install neovim v0.5+
* for easier editing of the files, create symlinks for the files/folders (then only edit in the git repo)
  * this can be done with the `./setup.sh` script, which will just add symlinks
* in nvim run `:PlugInstall` this will install the Plugins from **vim-plug** set in `~/.config/nvim/init.vim`
* install [Language Servers/Extensions](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-extension-for-programming-languages-you-use-daily) for coc.nvim
  * most of my used extensions are already in the `init.vim`, and will be installed automatically
  * coc will enable `emmet` functionality next to the "normal" language server protocols
  * use marketplace for easy search of wanted extensions with `:CocList marketplace`
* bind capslock to escape
  * ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."
