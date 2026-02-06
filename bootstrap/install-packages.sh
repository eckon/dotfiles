#!/usr/bin/env bash

set -euo pipefail

####################################################
# script to install all packages depending on the OS
####################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$SCRIPT_DIR/packages"

# helper function to parse YAML package files and extract package names
parse_packages() {
  local file="$1"

  if [[ "$file" != *.yaml ]]; then
    echo "Error: parse_packages only accepts .yaml files, got: $file" >&2
    return 1
  fi

  # parse YAML: extract values from lists, ignore comments and keys
  grep -E '^\s*-\s+' "$file" | sed -E 's/^\s*-\s+([^ #]+).*/\1/' || true
}

if command -v "yay" &> /dev/null; then
  # update all installed packages first
  yay -Syu --noconfirm

  # install base packages
  # shellcheck disable=SC2046
  yay -S --noconfirm --needed $(parse_packages "$PACKAGE_ROOT/yay-packages.yaml")

  echo ""
  echo "[!] For window manager specific packages, run one of:"
  printf "    yay -S --needed \$(grep -E '^\\s*-\\s+' %s/yay-hyprland.yaml | sed -E 's/^\\s*-\\s+([^ #]+).*/\\1/')\n" "$PACKAGE_ROOT"
  printf "    yay -S --needed \$(grep -E '^\\s*-\\s+' %s/yay-niri.yaml | sed -E 's/^\\s*-\\s+([^ #]+).*/\\1/')\n" "$PACKAGE_ROOT"

  # cleanup
  yay -Yc --noconfirm
  yay -Sc --noconfirm
fi

if command -v "apt" &> /dev/null; then
  sudo apt update
  sudo apt upgrade -y
  parse_packages "$PACKAGE_ROOT/apt-packages.yaml" | xargs sudo apt install -y
  sudo apt autoremove -y
fi

if command -v "dnf" &> /dev/null; then
  sudo dnf check-update
  sudo dnf upgrade -y
  parse_packages "$PACKAGE_ROOT/dnf-packages.yaml" | xargs sudo dnf install -y
  sudo dnf autoremove -y
fi

if command -v "brew" &> /dev/null; then
  brew update
  brew upgrade
  brew bundle --file "$PACKAGE_ROOT/Brewfile"
  brew cleanup
fi

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
    # NOTE: there is a nightly neovim aur package, but i dont use it to handle it myself willingly
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
