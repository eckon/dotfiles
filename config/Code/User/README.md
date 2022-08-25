# VSCode

## Setup

### Plugins

- Using the [VsCodeVim](https://github.com/VSCodeVim/Vim) plugin to emulate basic vim functionality
  - This uses neovim as a backend for commands like global etc

- Reason to not use the [Neovim VsCode](https://github.com/asvetliakov/vscode-neovim) Plugin
  - A lot of vscode functions that are based on the view break
    - Git diff view does not work well
    - History gets broken easily (vscode and vim have independent histories which makes losing them easy)
    - Some completions are not working because neovim replaces the whole view
  - The commands have no history (no way to easily repeat a global command etc)
  - Not as fine tuned to VsCode as the other vim plugin

- Generally these are some of the plugins I use mostly:
  - aaron-bond.better-comments
  - coenraads.disableligatures
  - liximomo.sftp
  - pkief.material-icon-theme
  - vscodevim.vim
  - yzhang.markdown-all-in-one


## Useful links

- [vscodevim mappings](https://github.com/VSCodeVim/Vim/#-vscodevim-tricks)
- [vscode-mappings and namings](https://code.visualstudio.com/docs/getstarted/keybindings#_rich-languages-editing)
