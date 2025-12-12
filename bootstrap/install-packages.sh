#!/usr/bin/env bash

####################################################
# script to install all packages depending on the OS
####################################################

PACKAGE_ROOT="$(pwd)/bootstrap/packages"

if command -v "yay" &> /dev/null; then
  # update all
  yay -Syu

  while read -r pkg; do
    if ! pacman -Qi "$pkg" &> /dev/null; then
      # do installation interactively to prevent installing incorrect packages
      yay "$pkg" < /dev/tty
    else
      echo "Skipped (already installed): $pkg"
    fi
  done < "$PACKAGE_ROOT/yay-packages.txt"

  # cleanup
  yay -Yc --noconfirm
  yay -Sc --noconfirm
fi

if command -v "apt" &> /dev/null; then
  sudo apt update
  sudo apt upgrade -y
  cat "$PACKAGE_ROOT/apt-packages.txt" | xargs sudo apt install -y
  sudo apt autoremove -y
fi

if command -v "dnf" &> /dev/null; then
  sudo dnf check-update
  sudo dnf upgrade -y
  cat "$PACKAGE_ROOT/dnf-packages.txt" | xargs sudo dnf install -y
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
