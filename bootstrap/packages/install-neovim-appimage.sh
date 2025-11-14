#!/usr/bin/env bash

LOCAL_BIN_PATH="$HOME/.local/bin"
NVIM_PATH="$LOCAL_BIN_PATH/nvim"
FORCE_FLAG=false

mkdir -p "$LOCAL_BIN_PATH"
mkdir -p "/tmp/neovim"

if [[ "$1" == "--force" ]]; then
  FORCE_FLAG=true
fi

if command -v "nvim" &> /dev/null && [[ "$FORCE_FLAG" == false ]]; then
  exit
fi

echo "[+] Install \"nvim\""

curl -L -o "/tmp/neovim/nvim.appimage" \
  "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage"

# Verify download was successful
if [[ ! -f "/tmp/neovim/nvim.appimage" ]]; then
  echo "[-] Failed to download neovim appimage"
  exit 1
fi

chmod +x "/tmp/neovim/nvim.appimage"

# Test that the appimage works before replacing existing installation
if ! "/tmp/neovim/nvim.appimage" --version &> /dev/null; then
  echo "[-] Downloaded neovim appimage is not working"
  exit 1
fi

# Only move old neovim after successful download and verification as a backup
if [[ "$FORCE_FLAG" == true ]] && [[ -f "$NVIM_PATH" ]]; then
  echo "[!] Move old neovim installation"
  mv "$NVIM_PATH" "$NVIM_PATH.old"
fi

cp "/tmp/neovim/nvim.appimage" "$NVIM_PATH"

# setup neovim to be used in `sudoedit`
if command -v nvim > /dev/null 2>&1; then
  # only trigger this, if we already have sudo permissions (via general install packages)
  if sudo -n true > /dev/null 2>&1; then
    # handle os/envs where I do not have this command (later on I should handle other commands as well)
    if command -v update-alternatives > /dev/null 2>&1; then
      sudo update-alternatives --install /usr/bin/editor editor "$(command -v nvim)" 110
      sudo update-alternatives --set editor "$(command -v nvim)"
    fi
  fi
fi
