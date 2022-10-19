# Neovim / Vim

My ever changing setup for neovim as a development editor.

It focuses (mostly) on the linux philosophy "Do One Thing and Do It Well", meaning that parts that some people might have in their vim config are not present here.

Tmux is being used as an easy way to run multiple vim instances and having the freedom of using emulators everywhere.
This also extends to things like git, scripts, commands which could be done in vim, but are not here, or only used in limit within vim.

The structure tries to be easy to read and change, it is written with lua, meaning a lsp will help jumping to the different parts.
Lua based configuration also allows for easy standardized formatting via `stylua`.

[init.lua](./init.lua) is the entry point and has multiple parts, which can be found in the `lua` folder.


## Install

- if the main `install script` was run, the following will be available
  - nightly [neovim](https://github.com/neovim/neovim)
  - newest [packer](https://github.com/wbthomason/packer.nvim)
- `:PackerInstall` needs to be run on the first startup
  - the first startup might throw errors, but these should disappear after installing the plugins
- on second startup, `LSP`, `Treesitter` and others should update/install automatically
- run `:checkhealth` to see if something is missing


## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)