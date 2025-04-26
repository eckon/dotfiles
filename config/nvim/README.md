# Neovim / Vim

My ever changing setup for neovim as a development editor.

It focuses (mostly) on the linux philosophy "Do One Thing and Do It Well",
meaning parts that some people have in their editor might not be present here.

A Terminal Multiplexer (Tmux/Zellij) is being used as an easy way to run multiple vim instances and
having the freedom of using emulators everywhere.
This also extends to things like git, scripts, commands or other external tools which could be done in vim.

The configuration is managed as a basic lua project, meaning that navigation and extension can be done
programmatically and should be somewhat easy with jump to definition, autocompletion and other lsp features.

Lua formatting is handled via [stylua](https://github.com/JohnnyMorganz/StyLua) and
type annotations can be done via [sumneko](https://github.com/LuaLS/lua-language-server/wiki/Annotations)
see [wiki](https://luals.github.io/wiki/annotations/) for more information.

[init.lua](./init.lua) is the entry point and has multiple parts,
it will install a plugin manager which then handles/installs/updates the plugins located in `lua/eckon/plugins`.
Vim will load other parts itself, like `after/ftplugin`, `plugin`, `lsp` and `plugin` so these include configurations.
Last part are some helper scripts which can be found in `lua/eckon`.

## Install

- after the `setup script` was run we should have
  - nightly [neovim](https://github.com/neovim/neovim)
- the first startup will automatically install different things
  - plugin manager
  - plugins
  - treesitters
  - lsps
  - linters
  - formatters
  - etc
- for the initial start, this means it will take some time until everything is installed
  - just wait until it looks fine
  - early closing and restarting should be fine and fix itself over time
- run `:checkhealth` to see if something is missing

## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)
