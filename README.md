# Collection of my dotfiles and scripts

This repository contains my public **scripts** and **configurations** for various development tools and environments.

## Quick Start

```bash
git clone https://github.com/eckon/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
just setup
```

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

### Prerequisites

- `git` - To clone this repository
- `just` (optional) - To execute setup scripts

### Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/eckon/dotfiles.git ~/Development/dotfiles
   cd ~/Development/dotfiles
   ```

2. **Run the setup:**

   ```bash
   just setup
   ```

   Alternatively, manually execute the setup steps (see [`justfile`](./justfile))

3. **For development:**

   ```bash
   npm install # For local formatting, linting and more
   ```

The setup script will:

- Install terminal tools and applications
- Create symlinks to configuration files
- Set up development environment
- Handle different operating systems automatically

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
