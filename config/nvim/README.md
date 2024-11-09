# Neovim / Vim

My ever changing setup for neovim as a development editor.

It focuses (mostly) on the linux philosophy "Do One Thing and Do It Well",
meaning parts that some people might have in their vim config are not present here.

A Terminal Multiplexer (Tmux/Zellij) is being used as an easy way to run multiple vim instances and
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
it will install a plugin manager which will then handle/install/update the plugins located in `lua/eckon/plugins`.
Vim will load other parts itself, like `after/ftplugin` and `plugin` so these include configurations.
Last part are some helper scripts which can be found in `lua/eckon`.

## Install

- if the main `install script` was run, the following will be available
  - nightly [neovim](https://github.com/neovim/neovim)
- the first startup will automatically install different things
  - packages
  - treesitter
  - lsp
  - linter
  - formatter
  - etc
- because of this is will take some time and might throw some errors,
  just wait until its done and reopen vim
- on second startup, `LSP`, `Treesitter` and others should update/install automatically
- run `:checkhealth` to see if something is missing

## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)

## Special

Similar to others, my vim setup does not handle gigantic files well,
things like multiple `MB` of `json` or `millions of lines` of some `language`/`format`
will result in problems with `lsp`, `treesitter`,
`custom plugins` and `highlight` in general,
slowing down or potentially even crashing `vim`.

For this case there are two ways of handling it,
either every file will be initialized differently
or we do not allow gigantic files.

My setup has two modes, a `normal` mode and a `performance`/`minimal` mode.
The `normal` vim will not allow big files, it wipes them before loading them.

Additionally there is another `minimal` mode vim via the `vi` command,
which can handle these gigantic files well (its close to bare bones vim).
This is being done by passing the `run_minimal` variable to vim (see `fish` config),
disabling multiple known sources of problems for big files.
