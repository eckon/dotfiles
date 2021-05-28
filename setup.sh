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

symlink .config/Code/User/keybindings.json
symlink .config/Code/User/settings.json
symlink .config/fish/config.fish
symlink .config/kitty/kitty.conf
symlink .config/lazygit/config.yml
symlink .config/nvim
symlink .config/starship.toml
symlink .zshrc
