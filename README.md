# Collection of my dotfiles and scripts

## Neovim / Vim

The [README.md](./.config/nvim/README.md) and configuration can be found in the [nvim-config folder](./.config/nvim).


## Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


## Used software

Following programs are installed:
* [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
  * [powerlevel10k](https://github.com/romkatv/powerlevel10k)
  * Additional plugins that are not in oh-my-zsh have to be installed in `$ZSH_CUSTOM/custom/plugins`
    * [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    * [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
* [awesome wm](https://awesomewm.org/)
  * [compton](https://github.com/chjj/compton)
  * [rofi](https://github.com/davatorium/rofi)
  * [polybar](https://github.com/polybar/polybar)
  * [nitrogen](https://github.com/l3ib/nitrogen)
  * suckless-tools
    * [slock](https://tools.suckless.org/slock/)
    * [dmenu](https://tools.suckless.org/dmenu/)
* [tmux](https://github.com/tmux/tmux)
* [neovim](https://github.com/neovim/neovim) (v0.5.0+)
* [vim-plug](https://github.com/junegunn/vim-plug)
* [fzf](https://github.com/junegunn/fzf)
  * [bat](https://github.com/sharkdp/bat) (this is needed for fzf.vim syntax highlight)
* [xclip](https://wiki.ubuntuusers.de/xclip/) (this is to synchronize the clipboards in tmux/terminal/nvim)
* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) (used as the default search algorithm)
* ([ripgrep](https://github.com/BurntSushi/ripgrep))
* [tldr](https://github.com/tldr-pages/tldr)


### On fresh install

Following commands/configs should be run/set on fresh install:
* for easier editing of the files, create symlinks for the files (then only edit in the git repo)
  * the nvim/awesome/rofi directory can be linked completely
  * `$ ln -s ~/path/to/dotfiles/.config/nvim ~/.config/nvim`
  * `wallpapers` should be linked to `~/Pictures/wallpapers/`
* in nvim run `:PlugInstall` this will install the Plugins from **vim-plug** set in `~/.config/nvim/init.vim`
* install [Language Servers/Extensions](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-extension-for-programming-languages-you-use-daily) for coc.nvim
  * most of my used extensions are already in the `init.vim`, and will be installed automatically
  * coc will enable `emmet` functionality next to the "normal" language server protocols
  * use marketplace for easy search of wanted extensions with `:CocList marketplace`
* bind capslock to escape
  * ubuntu: Install Tweaks and set it in "Keyboard" -> "Additional Layout Options" -> "Esc..."
* unbind system super bindings for Tiling Window Manager
