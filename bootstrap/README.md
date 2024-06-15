# Bootstrap scripts

## Setup scripts

Contains idempotent scripts for setting up a new environment, mainly to symlink and install packages.

- `install-packages.sh` installs all packages
  - different files that include bundles of packages for other tools
    - `Brewfile` for `brew`
    - `apt-packages.txt` for `apt`
  - specific installation scripts for other tools
    - for example `install-neovim.sh` for `neovim`
  - is setup to be used with different OSes in the future
- `symlink.sh` symlinks all my local configurations and scripts
