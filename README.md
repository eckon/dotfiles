# Collection of my dotfiles and scripts

This repository contains my public **scripts** and **configurations** for various development tools and environments.

## Documentation

Each major component has its own README:

- [Neovim](./config/nvim/README.md) - Vim configuration and plugins
- [OpenCode](./config/opencode/README.md) - AI assistant tools and extensions
- [Scripts](./scripts/README.md) - Custom shell scripts and utilities
- [Bootstrap](./bootstrap/README.md) - Setup and installation scripts
- [Visual Studio Code](./config/vscode/README.md) - VSCode settings and keybindings
- [Visual Studio](./config/visual-studio/README.md) - Visual Studio configuration
- [Jetbrains Tools](./config/jetbrains/README.md) - IntelliJ IDEA and related IDEs
- [Gists](https://gist.github.com/eckon) - Additional code snippets

## Installation

```bash
git clone https://github.com/eckon/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
sudo -v
./bootstrap/install-packages.sh
./bootstrap/symlink.sh
```

_Additionally (optionally) run `npm install` for local formatting, linting and more_

The setup script will:

- Install terminal tools and applications
- Create symlinks to configuration files
- Set up development environment
- Handle different operating systems automatically
  - Only personally used ones are tested/maintained

### Post-Installation

`just` cli command is available and can be used for many other scripts (including the setup scripts)

## Directory Structure

```text
~/
├── .config/                   # Real configuration files (symlinked)
├── Development/
│   ├── dotfiles/              # This repository (central config)
│   ├── personal/              # Personal projects
│   └── work/                  # Work-related projects
```

### Configuration Management

- **Configuration files** are symlinked from this repository to `~/.config/`
- **Work-specific git config** should be placed in `~/.config/git/work` (not versioned)

## Used Software

See the [packages directory](./bootstrap/packages/) for the complete list.

- **[Brewfile](./bootstrap/packages/Brewfile)**
- **[apt-packages.txt](./bootstrap/packages/apt-packages.txt)**
- **[dnf-packages.txt](./bootstrap/packages/dnf-packages.txt)**
