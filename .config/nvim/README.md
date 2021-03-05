# Neovim / Vim

## Structure of nvim configuration

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)

## General Information

- Show color examples
  - `:source $VIMRUNTIME/syntax/hitest.vim`

## Native LSP

The Language-Servers need to be installed manually, they can be found under [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md).
Just look into `init.vim ` to see which servers are required (or see on which files I get an error).

Additionally there is a [script](./install-language-servers.sh) that installs all the needed Language-Servers.
