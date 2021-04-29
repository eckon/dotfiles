# Neovim / Vim

## Structure of neovim configuration

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)


## Setup

- in neovim run `:PlugInstall` this will install the Plugins from **vim-plug**
- run `:checkhealth` to see what is still needed or any problems with neovim


## VSCode: Embedded Neovim

Install:
- vscode
  - which points to the vscode.vim config file
- neovim plugin for vscode
- neovim v0.5+
  - if neovim plugins are not installed, do a :PlugInstall


### Useful links

- [plugin-mappings](https://github.com/asvetliakov/vscode-neovim#vscode-specific-features-and-differences)
- [vscode-mappings and namings](https://code.visualstudio.com/docs/getstarted/keybindings#_rich-languages-editing) which could be used like [vscode command in neovim](https://github.com/asvetliakov/vscode-neovim#invoking-vscode-actions-from-neovim)
