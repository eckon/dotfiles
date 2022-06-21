# Neovim / Vim

My ever changing setup for neovim as a development editor.

It focuses (mostly) on the linux philosophy "Do One Thing and Do It Well", meaning that parts that some people might have in their vim config are not present here.

Tmux is being used as an easy way to run multiple vim instances and having the freedom of using emulators everywhere. This also extends to things like git, scripts, commands which could be done in vim, but are not here.

The structure tries to be easy to read and change, that's one of the main reasons everything is in one file (for now) - searching through one file is faster than having to cross-reference multiple files.

[init.vim](./init.vim) is the entry point and has multiple parts, which are indicated by comments. The config is grouped into parts with a specific task (LSP, Git, Statusline, etc.).


## LSP

`LSP` is handled by [coc](https://github.com/neoclide/coc.nvim) and automatically installed with nvim.

Notes:
- update of references after file-rename is only possible with external [watchman](https://facebook.github.io/watchman/) program (but might depend on the given `LSP`)
  - the trigger of the rename action does not matter (file-tree, command-line, vim, etc.) it will be handled as long as the `LSP` is attached to a vim instance, which will show a prompt to update the other references


## Install

- if the main `install script` was run, the following will be available
  - nightly [neovim](https://github.com/neovim/neovim)
  - newest [vim-plug](https://github.com/junegunn/vim-plug)
- `:PlugInstall` needs to be run on the first startup (might need to press `q` to quit error messages)
- on second startup, `LSP`, `Treesitter` and others should update/install automatically
- run `:checkhealth` to see if something is missing


## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)
