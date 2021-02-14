#!/usr/bin/env bash

echo "[!] Start: Linking of dotfiles"

dotfilesDirectory=$(pwd)

function symlink {
  destination="${HOME}/${1}"
  # add new line for better formatting
  echo ""

  if [ -h "${destination}" ]; then
    echo "[-] Removing existing symlink: \"${destination}\""
    rm "${destination}"

  elif [ -f "${destination}" ]; then
    echo "[~] Moving existing file: \"${destination}\""
    mv "${destination}" "${destination}.old"

  elif [ -d "${destination}" ]; then
    echo "[~] Moving existing dir: \"${destination}\""
    mv "${destination}" "${destination}.old"
  fi

  base="${dotfilesDirectory}/${1}"
  echo "[+] Creating new symlink: \"${1}\""
  echo "[!] ${base} -> ${destination}"
  ln -s "${base}" "${destination}"
}

symlink .config/starship.toml
symlink .config/nvim
symlink .config/lazygit
symlink .zshrc
