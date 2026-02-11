# Collection of my dotfiles and scripts

This repository contains my public **scripts** and **configurations** for various development tools and environments.

Hosted:

- [github](https://github.com/eckon/dotfiles)
- [codeberg](https://codeberg.org/eckon/dotfiles)

## Documentation

Each major component has its own README:

- [Neovim](./config/nvim/README.md) - Vim configuration and plugins
- [OpenCode](./config/opencode/README.md) - AI assistant tools and extensions
- [Scripts](./scripts/README.md) - Custom shell scripts and utilities
- [Bootstrap](./bootstrap/README.md) - Setup and installation scripts
- [Visual Studio Code](./config/vscode/README.md) - VSCode settings and keybindings
- [Visual Studio](./config/visual-studio/README.md) - Visual Studio configuration
- [Jetbrains Tools](./config/jetbrains/README.md) - IntelliJ IDEA and related IDEs

## Installation

```bash
git clone git@github.com:eckon/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
sudo -v
./bootstrap/install-packages.sh
./bootstrap/symlink.sh
# and the specific installation of the setup (see ./bootstrap/packages/install-packages-*)
```

_Additionally (optionally) run `npm install` for local formatting, linting and more_

### Post-Installation

`mise` cli command is available and can be used for many other scripts (including the setup scripts):

```bash
mise tasks                       # List all available tasks
mise run setup                   # Run full setup (update + install + symlinks)
mise run packages:update         # Update all packages
mise run check                   # Format and lint all code
```

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

- **[install-packages-yay.sh](./bootstrap/packages/install-packages-yay.sh)** - Arch Linux packages
- **[install-packages-apt.sh](./bootstrap/packages/install-packages-apt.sh)** - Debian/Ubuntu packages
- **[install-packages-dnf.sh](./bootstrap/packages/install-packages-dnf.sh)** - Fedora packages
- **[install-packages-brew.sh](./bootstrap/packages/install-packages-brew.sh)** - macOS packages
