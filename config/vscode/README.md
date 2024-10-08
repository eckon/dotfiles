# VSCode

## Important default keybindings

Some of these might be doable with other configurations like vim plugin

- `Open file` -> `CTRL-P`
- `Command Pallet` -> `CTRL-SHIFT-P`

## Useful links

- [vscodevim mappings](https://github.com/VSCodeVim/Vim/#-vscodevim-tricks)
- [vscode-mappings and namings](https://code.visualstudio.com/docs/getstarted/keybindings#_rich-languages-editing)

## Setup

### Plugins

- Generally these are some of the plugins I use mostly:
  - theme
    - qufiwefefwoyn.kanagawa
  - ai
    - GitHub.copilot
      - also the other experimental features
  - vim
    - vscodevim.vim
      - > [!NOTE]
        > additional setting for WSL -> vim plugin is installed on local machine -> configure vimrc path
        > in local settings, set the vimrc path into the wsl, this is not versioned so needs to be done manually
        > example: `das`
    - _asvetliakov.vscode-neovim_
  - spelling
    - streetsidesoftware.code-spell-checker
      - for the general spell check in code
    - streetsidesoftware.code-spell-checker-german
      - to add german spelling as well (setting is already set in config)

#### Vim plugins

- vim
  - better integration with vscode
  - better out of the box features
- neovim
  - work well enough
    - but many things need to be done via neovim plugins (commenting, surround, etc.)
    - so it is not independent of my neovim setup, which I want to prevent for now
