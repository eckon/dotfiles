# Collection of my dotfiles

General rule: **Install latest Version, meaning check if apt is up-to-date**

Following programs are installed:
* [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
  * [powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [tmux](https://github.com/tmux/tmux)
* [neovim](https://github.com/neovim/neovim)
* [vim-plug](https://github.com/junegunn/vim-plug)
* [fzf](https://github.com/junegunn/fzf)
  * [bat](https://github.com/sharkdp/bat) (this is needed for fzf.vim syntax highlight)
* [xclip](https://wiki.ubuntuusers.de/xclip/) (this is to synchronize the clipboards in tmux/terminal/nvim)
* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) (used as the default search algorithm)
* ([ripgrep](https://github.com/BurntSushi/ripgrep))
* [tldr](https://github.com/tldr-pages/tldr)

Following commands should be run on fresh install:
* For easier editing of the files, create symlinks for the files (then only edit in the git repo)
  * Be in the home dir and add smylink `$ ln -s ~/path/to/github/dotfiles/.dotfile .dotfile`
* In nvim run `:PlugInstall` this will install the Plugins from **vim-plug** set in `~/.config/nvim/init.vim`
* Install [Language Servers/Extensions](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-extension-for-programming-languages-you-use-daily) for coc.nvim
  * Coc will enable `emmet`, `auto-pairs` and `yank-highlighting` functionality next to the "normal" language server protocols
  * Install `:CocInstall coc-marketplace` for easy search of wanted extensions with `:CocList marketplace`
  * Example
    * Essential: `:CocInstall coc-emmet coc-yank coc-pairs`
    * General: `:CocInstall coc-json coc-html coc-yaml coc-vimlsp coc-docker`
    * Specific: `:CocInstall coc-tsserver coc-css coc-prettier coc-eslint coc-tslint coc-phpls coc-angular coc-go coc-python coc-java coc-rls`

