#!/usr/bin/env bash

if echo "$SHELL" | grep -qF "fish"; then
  exit
fi

echo "[+] Add fish as default shell"

SHELLS_PATH="/etc/shells"
FISH_PATH=$(which fish)

grep -qxF "$FISH_PATH" "$SHELLS_PATH" \
  || (echo "$FISH_PATH" | sudo tee -a "$SHELLS_PATH")

chsh -s "$FISH_PATH"
