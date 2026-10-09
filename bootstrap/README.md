# Bootstrap scripts

Idempotent scripts for setting up a new environment. Nothing detects the OS, pick what fits manually.

- `symlink.sh` symlinks all my local configurations and scripts (`mise run symlinks`)
- `update-packages.sh` updates all packages of every available package manager (`mise run update`)
- `packages/` contains the install scripts, each available as `mise run packages:install-*`

## Install per OS

The package manager itself (`yay`, `brew`, ...) needs to be installed first.

### Arch

- `mise run packages:install-yay`
- `mise run packages:install-neovim` (own nightly appimage instead of the AUR package)

### macOS

- `mise run packages:install-brew`
- `mise run packages:install-fish`
- Manually install neovim into `~/.local/bin`
- Manually install ghostty
- Manually install FiraCode Nerd Font

### Other Linux (Debian/Ubuntu, Fedora)

- `mise run packages:install-apt` or `mise run packages:install-dnf` (build tools only)
- `mise run packages:install-brew` for the actual tools, after installing brew
- `mise run packages:install-fish`
- `mise run packages:install-neovim`
- `mise run packages:install-font`
- Manually install ghostty

### WSL

- Same as other Linux, except fonts and terminal live on the Windows side
- Manually install FiraCode Nerd Font on Windows and set it in the terminal
