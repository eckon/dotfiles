# Collection of my dotfiles and scripts

This repository includes all of my public _**scripts**_
and _**configurations**_ of different parts.

Bigger parts have their own README and can be found here:

- [Neovim](./config/nvim/README.md)
- [Scripts](./scripts/README.md)
- [Bootstrap](./bootstrap/README.md)
- [Visual Studio Code](./config/vscode/README.md)
- [Visual Studio](./config/visual-studio/README.md)
- [Jetbrains Tools](./config/jetbrains/README.md)
- [Gists](https://gist.github.com/eckon)

## Install

Installation of everything in my configuration:

- install `git`
  - optionally `just`
- clone this repository
- run setup scripts
  - if `just` is installed just do `just setup`
    - otherwise look in the `justfile` and run the scripts under `setup` manually
  - this will install the different parts for a quick setup (terminal, tools, symlinks, configs, etc.)
  - should correctly handle the different OSes

## System Structure

- `~` and `~/.config/`
  - includes the "real" configurations
- `~/Development/dotfiles/`
  - has this project inside, acts as a central configuration place
- `~/Development/personal/`
  - has my personal projects
- `~/Development/work/`
  - has work related projects
  - create a `.config/git/work` file (similar to the default `.config/git/config`

## Used software

Following programs should be highlighted and are installed/used:

- [kitty](https://github.com/kovidgoyal/kitty) _with_
  [fira code](https://github.com/tonsky/FiraCode),
  [starship](https://github.com/starship/starship)
- [fish](https://github.com/fish-shell/fish-shell) _with_
  [tmux](https://github.com/tmux/tmux)
- [neovim](https://github.com/neovim/neovim)
- [lazygit](https://github.com/jesseduffield/lazygit) _with_
  [delta](https://github.com/dandavison/delta)
- [zoxide (z)](https://github.com/ajeetdsouza/zoxide),
  [tldr](https://github.com/tldr-pages/tldr),
  [fzf](https://github.com/junegunn/fzf),
  [ripgrep](https://github.com/BurntSushi/ripgrep),
  [fd](https://github.com/sharkdp/fd),
  [bat](https://github.com/sharkdp/bat),
  [jq](https://github.com/stedolan/jq),
  [fnm](https://github.com/Schniz/fnm),
  [brew](https://github.com/Homebrew/brew)
