#!/usr/bin/env bash

####################################################
# script to install all packages depending on the OS
####################################################

package_root="$(pwd)/bootstrap/packages"

sudo apt update
sudo apt upgrade -y
cat "$package_root/apt-packages.txt" | xargs sudo apt install -y

if ! command -v "brew" &> /dev/null; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew bundle --file "$package_root/Brewfile"


current_os="$(cat /proc/version)"
case "$(echo "$current_os" | tr "[:upper:]" "[:lower:]")" in

# wsl installation has `wsl` and `linux` in the output, but only `wsl` will be matched
*'wsl'*)
    echo "[!] Install for WSL"
    "$package_root/install-fish.sh"
    "$package_root/install-neovim.sh"
    "$package_root/install-font.sh"
    ;;

*'linux'*)
    echo "[!] Install for Linux"
    "$package_root/install-fish.sh"
    "$package_root/install-neovim.sh"
    "$package_root/install-font.sh"
    "$package_root/install-kitty.sh"
    ;;

  *)
    echo "[!] Unknown OS: \"$current_os\""
    ;;
esac
