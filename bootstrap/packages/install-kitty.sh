#!/usr/bin/env bash

if command -v "kitty" &> /dev/null; then
  exit
fi

echo "[+] Install \"kitty\""

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
ln -sfn "$HOME/.local/kitty.app/bin/kitty" "$LOCAL_BIN_PATH"

mkdir -p "$HOME/.local/share/applications"
cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications"
cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications"

sed -i \
  "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
  "$HOME/.local/share/applications/kitty.desktop"

sed -i \
  "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" \
  "$HOME/.local/share/applications/kitty.desktop"
