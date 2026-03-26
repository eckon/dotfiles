#!/usr/bin/env bash

set -euo pipefail

######################################################################
# script to update all packages depending on the OS / package manager
######################################################################

if command -v "yay" &> /dev/null; then
  yay -Syu --noconfirm
  yay -Yc --noconfirm
  yay -Sc --noconfirm
  sudo rm -rf /var/cache/pacman/pkg/download-*
fi

if command -v "apt" &> /dev/null; then
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
fi

if command -v "dnf" &> /dev/null; then
  sudo dnf upgrade -y
  sudo dnf autoremove -y
fi

if command -v "brew" &> /dev/null; then
  brew update
  brew upgrade
  brew cleanup
fi

if command -v "flatpak" &> /dev/null; then
  flatpak update -y
  flatpak uninstall --unused -y
fi

if command -v "snap" &> /dev/null; then
  sudo snap refresh
fi
