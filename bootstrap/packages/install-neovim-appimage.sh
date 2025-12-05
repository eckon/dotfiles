#!/usr/bin/env bash

FORCE_FLAG=false
if [[ "$1" == "--force" ]]; then
  FORCE_FLAG=true
fi

if command -v "nvim" &> /dev/null && [[ "$FORCE_FLAG" == false ]]; then
  echo "[!] \"nvim\" exists, ignoring installation"
  exit
fi

# create unique temporary directory that will be cleaned up by
# cleanup trap for exit, interrupt (Ctrl-C), and termination
TMP_DIR=$(mktemp -d)
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

echo "[+] Download and Install \"nvim\""
curl -L -o "$TMP_DIR/nvim.appimage" \
  "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage"

echo "[+] Verify \"nvim\" download"
if [[ ! -f "$TMP_DIR/nvim.appimage" ]]; then
  echo "[!] Failed to download neovim appimage"
  exit 1
fi

echo "[+] Test \"nvim\" appimage"
chmod +x "$TMP_DIR/nvim.appimage"
if ! "$TMP_DIR/nvim.appimage" --version &> /dev/null; then
  echo "[!] Downloaded neovim appimage is not working"
  exit 1
fi

LOCAL_BIN_PATH="$HOME/.local/bin"
NVIM_PATH="$LOCAL_BIN_PATH/nvim"

mkdir -p "$LOCAL_BIN_PATH"

if [[ "$FORCE_FLAG" == true ]] && [[ -f "$NVIM_PATH" ]]; then
  echo "[!] Move old neovim installation"
  mv "$NVIM_PATH" "$NVIM_PATH.old"
fi

echo "[!] Move \"nvim\" into PATH"
cp "$TMP_DIR/nvim.appimage" "$NVIM_PATH"

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
