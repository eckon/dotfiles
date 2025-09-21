# Collection of my dotfiles and scripts

This repository includes all of my public _**scripts**_
and _**configurations**_ of different parts.

Bigger parts have their own README and can be found here:

- [Neovim](./config/nvim/README.md)
- [OpenCode](./config/opencode/README.md)
- [Scripts](./scripts/README.md)
- [Bootstrap](./bootstrap/README.md)
- [Visual Studio Code](./config/vscode/README.md)
- [Visual Studio](./config/visual-studio/README.md)
- [Jetbrains Tools](./config/jetbrains/README.md)
- [Gists](https://gist.github.com/eckon)

## Install

Installation of everything in my configuration:

- pre-requirements
  - `git` to clone this repository
  - _`just` (optional) to execute different scripts_
- run `just setup`
  - _or manually execute the `setup` step, see [justfile](./justfile)_
  - this will install the different parts for a quick setup (terminal, tools, symlinks, configs, etc.)
  - should handle the different OS's
  - for local formatting/development also run `npm install`

## System Structure

- `~` and `~/.config/`
  - includes the "real" configurations
  - will symlink to the this project
- `~/Development/dotfiles/`
  - has this project inside, acts as a central configuration place
- `~/Development/personal/`
  - has my personal projects
- `~/Development/work/`
  - has work related projects
  - use a `.config/git/work` file to handle work related git configurations
    - these should not be versioned, and therefore need to be added manually

## Used software

Used software can be found here:

- [packages](./bootstrap/packages/) which mostly includes
  - [Brewfile](./bootstrap/packages/Brewfile)
  - [apt-packages.txt](./bootstrap/packages/apt-packages.txt)
  - and other specific scripts
