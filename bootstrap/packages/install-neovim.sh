#!/usr/bin/env bash

LOCAL_BIN_PATH="$HOME/.local/bin"
NVIM_PATH="$LOCAL_BIN_PATH/nvim"

mkdir -p "$LOCAL_BIN_PATH"
mkdir -p "/tmp/neovim"

if [[ "$1" == "--force" ]]; then
  echo "[!] Move old neovim installation"
  mv "$NVIM_PATH" "$NVIM_PATH.old"
fi

if command -v "nvim" &> /dev/null; then
  exit
fi

echo "[+] Install \"nvim\""

wget -O "/tmp/neovim/nvim.appimage" \
  "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"

chmod +x "/tmp/neovim/nvim.appimage"
cp "/tmp/neovim/nvim.appimage" "$NVIM_PATH"
