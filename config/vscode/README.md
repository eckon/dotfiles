# VSCode

## Important default keybindings

Some of these might be doable with other configurations like vim plugin

- `Open file` -> `CTRL-P`
- `Command Palette` -> `CTRL-SHIFT-P`

## Useful links

- [vscodevim mappings](https://github.com/VSCodeVim/Vim/#-vscodevim-tricks)
- [vscode-mappings and namings](https://code.visualstudio.com/docs/getstarted/keybindings#_rich-languages-editing)
  - generally checkout `Keyboard Shortcuts` in `vscode` for a view that can be filtered

## Setup

### Plugins

Generally these are some of the plugins I use mostly:

- theme
  - `qufiwefefwoyn.kanagawa`
- ai
  - `GitHub.copilot`
- vim
  - `vscodevim.vim`
    - > [!NOTE]
      > When installed in `wsl` there are two settings location, one in `wsl` and one in `windows`
      > Some vim settings like keybindings are configured in Windows and therefore need
      > to be copy&pasted manually into `windows` (as there is no symlink)
      > check via `vscode` and "settings" to get the location of each
  - _`asvetliakov.vscode-neovim`_
    - an alternative but not used (because of previous vim tool)
- formatter (for some languages a formatter is recommended)
  - `esbenp.prettier-vscode` for js/ts

#### Vim plugins

- vim
  - better integration with vscode
  - better out of the box features
- neovim
  - work well enough
    - but many things need to be done via neovim plugins (commenting, surround, etc.)
    - so it is not independent of my neovim setup, which I want to prevent for now
