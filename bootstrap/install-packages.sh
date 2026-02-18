#!/usr/bin/env bash

set -euo pipefail

####################################################
# script to install OS-specific packages
####################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$SCRIPT_DIR/packages"

echo "[!] This script installs OS-specific packages (neovim, fish, fonts, etc.)"
echo "[!] For package manager packages, run one of:"
echo "    - mise run packages:install-yay   (Arch Linux)"
echo "    - mise run packages:install-apt   (Debian/Ubuntu)"
echo "    - mise run packages:install-dnf   (Fedora)"
echo "    - mise run packages:install-brew  (macOS)"
echo ""

if [ -f /proc/version ]; then
  # wsl installation has `wsl` and `linux` in the output, but only `wsl` will be matched
  CURRENT_OS="$(cat /proc/version)"
else
  # mac has no /proc so we use the uname for that instead
  CURRENT_OS="$(uname -a)"
fi

case "$(echo "$CURRENT_OS" | tr "[:upper:]" "[:lower:]")" in
  *'wsl'*)
    echo "[!] Install for WSL"
    "$PACKAGE_ROOT/install-fish.sh"
    "$PACKAGE_ROOT/install-neovim-appimage.sh"
    if (command -v "fc-list" &> /dev/null && ! (fc-list | grep -qF "FiraCode Nerd Font")); then
      echo "[!] Manually install FiraCode Nerd Font and set in terminal"
    fi
    ;;

  *'arch'*)
    echo "[!] Install for Arch"
    # NOTE: there is a nightly neovim aur package, but I don't use it to handle it myself willingly
    "$PACKAGE_ROOT/install-neovim-appimage.sh"
    ;;

  *'linux'*)
    echo "[!] Install for general Linux"
    "$PACKAGE_ROOT/install-fish.sh"
    "$PACKAGE_ROOT/install-neovim-appimage.sh"
    "$PACKAGE_ROOT/install-font.sh"
    "$PACKAGE_ROOT/install-kitty.sh"
    ;;

  *'darwin'*)
    echo "[!] Install for Mac"
    "$PACKAGE_ROOT/install-fish.sh"
    echo "[!] Manually install neovim into ~/.local/bin"
    echo "[!] Manually install kitty"
    echo "[!] Manually install fonts"
    ;;

  *)
    echo "[!] Unknown OS: \"$CURRENT_OS\""
    ;;
esac
