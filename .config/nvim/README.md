# Neovim / Vim

## Structure of nvim configuration

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)

## General Information

- Show color examples
  - `:source $VIMRUNTIME/syntax/hitest.vim`

## VSCode: Embedded Neovim

Install vscode, install neovim plugin, use neovi v0.5+ (with the vscode.vim config file)

### Useful links

[plugin-mappings](https://github.com/asvetliakov/vscode-neovim#vscode-specific-features-and-differences)

[vscode-mappings and namings](https://code.visualstudio.com/docs/getstarted/keybindings#_rich-languages-editing) which could be used like [use vscode command in neovim](https://github.com/asvetliakov/vscode-neovim#invoking-vscode-actions-from-neovim)

## Native LSP

The Language-Servers need to be installed manually, they can be found under [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md).
Just look into `init.vim` to see which servers are required (or see on which files I get an error).

Additionally there is a [script](./install-language-servers.sh) that installs all the needed Language-Servers.
