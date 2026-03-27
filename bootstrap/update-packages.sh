#!/usr/bin/env bash

set -euo pipefail

######################################################################
# script to update all packages depending on the OS / package manager
######################################################################

if command -v "yay" &> /dev/null; then
  echo ""
  echo "########## yay ##########"
  echo ""
  yay -Syu --noconfirm
  yay -Yc --noconfirm
  yay -Sc --noconfirm
  sudo rm -rf /var/cache/pacman/pkg/download-*
fi

if command -v "apt" &> /dev/null; then
  echo ""
  echo "########## apt ##########"
  echo ""
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
fi

if command -v "dnf" &> /dev/null; then
  echo ""
  echo "########## dnf ##########"
  echo ""
  sudo dnf upgrade -y
  sudo dnf autoremove -y
fi

if command -v "brew" &> /dev/null; then
  echo ""
  echo "########## brew ##########"
  echo ""
  brew update
  brew upgrade
  brew cleanup
fi

if command -v "flatpak" &> /dev/null; then
  echo ""
  echo "########## flatpak ##########"
  echo ""
  flatpak update -y
  flatpak uninstall --unused -y
fi

if command -v "snap" &> /dev/null; then
  echo ""
  echo "########## snap ##########"
  echo ""
  sudo snap refresh
fi
