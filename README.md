# Collection of my dotfiles and scripts

## Custom scripts

The scripts and their [README.md](./custom-scripts/README.md) can be found in the [custom-scripts folder](./custom-scripts).


## Used software

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


### On fresh install

Following commands should be run on fresh install:
* For easier editing of the files, create symlinks for the files (then only edit in the git repo)
  * Be in the home dir and add smylink `$ ln -s ~/path/to/github/dotfiles/.dotfile .dotfile`
* In nvim run `:PlugInstall` this will install the Plugins from **vim-plug** set in `~/.config/nvim/init.vim`
* Install [Language Servers/Extensions](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-extension-for-programming-languages-you-use-daily) for coc.nvim
  * Most of my used extensions are already in the `init.vim`, and will be installed automatically
  * Coc will enable `emmet`, `auto-pairs` and `yank-highlighting` functionality next to the "normal" language server protocols
  * Use marketplace for easy search of wanted extensions with `:CocList marketplace`


## Information and Shortcuts for installed plugins

- vim-fugitive
  - in git-status
    - `=` show changes (on title or chunk)
    - `o` and `<ENTER>` to open file at chunk
    - `cc` will open commit window like `:Gcommit<ENTER>`
    - `dd` and `dv` will open diff-splitt
    - `s` will stage
      - works with visual mode
    - `u` will unstage
      - works with visual mode
    - `X` will checkout the changes (remove the changes)
- fzf (special symbols)
  - regex does not work in general (keep it simple)
  - `'` exact match
    - `'foo` -> match must have complete foo string
  - `!` do not match
    - `!foo` -> match can not have foo string
  - `^` match at start
    - `^foo` -> match must start with foo string
  - `$` match at end
    - `foo$` -> match must end with foo string
  - ` ` for AND (&&) operator
    - `foo bar` -> match must have foo and bar string
  - `|` for OR (||) operator
    - `foo | bar` -> match must have foo or bar string
  - `\ ` to use space as a character instead of an OR operator
    - `foo\ bar` -> return only when the string "foo bar" is matched
- nerdtree
  - `m` to open a modify window
    - `m` move/rename
    - `a` add
    - `d` delete

