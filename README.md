# Collection of my dotfiles and scripts

## Neovim / Vim

The [README.md](./.config/nvim/README.md) and configuration can be found in the [nvim-config folder](./.config/nvim).


## Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


## Used software

Following programs are installed:
* [kitty](https://github.com/kovidgoyal/kitty)
  * [fira code](https://github.com/tonsky/FiraCode)
* [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  * [antigen](https://github.com/zsh-users/antigen)
    * install in `~/.antigen/antigen.zsh` (seen in `.zshrc`)
  * [starship](https://github.com/starship/starship)
* [neovim](https://github.com/neovim/neovim) (v0.5.0+)
  * [vim-plug](https://github.com/junegunn/vim-plug)
  * [xclip](https://wiki.ubuntuusers.de/xclip/) (this is to synchronize the clipboards in terminal/nvim)
* [fzf](https://github.com/junegunn/fzf)
* [bat](https://github.com/sharkdp/bat)
* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
* ([ripgrep](https://github.com/BurntSushi/ripgrep))
* [fd](https://github.com/sharkdp/fd) (binary is `fdfind`: .zshrc has an alias to `fd`)
* [tldr](https://github.com/tldr-pages/tldr)
* [lazygit](https://github.com/jesseduffield/lazygit)
  * [delta](https://github.com/dandavison/delta) for better diff-views


### On fresh install

Following commands/configs should be run/set on fresh install:
* for easier editing of the files, create symlinks for the files/folders (then only edit in the git repo)
  * this can be done with the `./setup.sh` script, which will just add symlinks
* in nvim run `:PlugInstall` this will install the Plugins from **vim-plug** set in `~/.config/nvim/init.vim`
* install [Language Servers/Extensions](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-extension-for-programming-languages-you-use-daily) for coc.nvim
  * most of my used extensions are already in the `init.vim`, and will be installed automatically
  * coc will enable `emmet` functionality next to the "normal" language server protocols
  * use marketplace for easy search of wanted extensions with `:CocList marketplace`
* bind capslock to escape
  * ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."
