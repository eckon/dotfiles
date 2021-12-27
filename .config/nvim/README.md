# Neovim / Vim

My ever changing setup for neovim as a development editor.

It focuses (mostly) on the linux philosophy "Do One Thing and Do It Well", meaning that parts that some people might have in their vim config are not present here.

Tmux is being used as an easy way to run multiple vim instances and having the freedom of using emulators everywhere. This also extends to things like git, scripts, commands which could be done in vim, but are not here.

The structure tries to be easy to read and to change, that's one of the main reasons everything is in one file (for now) - searching through one file is faster than having to cross-reference multiple files.

[init.vim](./init.vim) is the entry point and has multiple parts, which are indicated by comments. The config is grouped into parts with a specific task (LSP, Git, Statusline, etc.).


## Install

- With ansible
  - ansible is already doing 90% of the work (download binary, installing packages, etc.)
  - the other 10% are being handled by neovim on first open
    - meaning the first run, might take some time because different parts need to be downloaded/installed

- Without ansible
  - download latest or nightly [neovim](https://github.com/neovim/neovim)
  - download [vim-plug](https://github.com/junegunn/vim-plug)
  - symlink this folder to the home directory (at least the `init.vim`)
  - start neovim and run the `general commands` to install and see if something needs to be fixed

- General commands to know (in neovim)
  - run `:PlugInstall` / `:PlugUpdate` this will install the Plugins from **vim-plug**
  - run `:checkhealth` to see what is still needed, any problems with neovim or problems with plugins


## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)
