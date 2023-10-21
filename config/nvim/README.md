# Neovim / Vim

My ever changing setup for neovim as a development editor.

It focuses (mostly) on the linux philosophy "Do One Thing and Do It Well",
meaning parts that some people might have in their vim config are not present here.

Tmux is being used as an easy way to run multiple vim instances and
having the freedom of using emulators everywhere.
This also extends to things like git, scripts, commands which could be done in vim,
but are not here, or only used in limit within vim.

The structure tries to be easy to read and change, it is written with lua,
meaning a lsp will help jumping to the different parts.
Lua based configuration also allows for easy standardized formatting
via [stylua](https://github.com/JohnnyMorganz/StyLua) and
type annotations can be done
via [sumneko](https://github.com/LuaLS/lua-language-server/wiki/Annotations)
see [wiki](https://luals.github.io/wiki/annotations/)

[init.lua](./init.lua) is the entry point and has multiple parts,
which can be found in the `lua` folder.

## Install

- if the main `install script` was run, the following will be available
  - nightly [neovim](https://github.com/neovim/neovim)
- the first startup will automatically install different things
  - packages
  - treesitter
  - lsp
  - linter
  - etc
- because of this is will take some time and might throw some errors,
  just wait until its done and reopen vim
- on second startup, `LSP`, `Treesitter` and others should update/install automatically
- run `:checkhealth` to see if something is missing

## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)

## Special

Sadly my config does not handle gigantic files always perfectly,
so for things like million lines of json or similar,
I added a global variable `run_minimal` which can be when calling vim and
will disable some of the more resource intense plugins.

This mainly includes `lsp`, `treesitter` and other things that take long or
do not handle gigantic files well.

For that the `vi` command is mapped to this minimal config
(and the normal `vim` / `nvim` to the full config).
