#!/usr/bin/env bash

if command -v "nvim" &> /dev/null; then
  exit
fi

echo "[+] Install \"nvim\""

LOCAL_BIN_PATH="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN_PATH"
mkdir -p "/tmp/neovim"

wget -O "/tmp/neovim/nvim.appimage" \
  "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"

chmod +x "/tmp/neovim/nvim.appimage"
cp "/tmp/neovim/nvim.appimage" "$LOCAL_BIN_PATH/nvim"
