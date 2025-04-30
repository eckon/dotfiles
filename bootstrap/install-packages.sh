#!/usr/bin/env bash

####################################################
# script to install all packages depending on the OS
####################################################

PACKAGE_ROOT="$(pwd)/bootstrap/packages"

sudo apt update
sudo apt upgrade -y
cat "$PACKAGE_ROOT/apt-packages.txt" | xargs sudo apt install -y
sudo apt autoremove -y

if ! command -v "brew" &> /dev/null; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew update
brew upgrade
brew bundle --file "$PACKAGE_ROOT/Brewfile"
brew cleanup

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

  *'linux'*)
    echo "[!] Install for Linux"
    "$PACKAGE_ROOT/install-fish.sh"
    "$PACKAGE_ROOT/install-neovim-appimage.sh"
    "$PACKAGE_ROOT/install-font.sh"
    "$PACKAGE_ROOT/install-kitty.sh"
    ;;

  *'darwin'*)
    echo "[!] Install for Mac"
    "$PACKAGE_ROOT/install-fish.sh"
    # prebuilt packages on mac are a bit finicky, for now I just use the stable neovim version
    brew install "neovim"
    ;;

  *)
    echo "[!] Unknown OS: \"$CURRENT_OS\""
    ;;
esac
