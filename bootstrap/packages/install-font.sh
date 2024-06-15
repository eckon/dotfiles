#!/usr/bin/env bash

if ! (command -v "fc-list" &> /dev/null && ! (fc-list | grep -qF "FiraCode Nerd Font")); then
  exit
fi

echo "[+] Install \"Patched FiraCode\" via \"Nerdfonts\""

# nerdfont is gigantic, only clone minimum (only root)
git clone --depth 1 --filter=blob:none --sparse \
  "https://github.com/ryanoasis/nerd-fonts.git" \
  "$HOME/.nerdfonts"

pushd "$HOME/.nerdfonts" || exit

# afterwards use sparse-checkout to furthermore only pull FiraCode
git sparse-checkout add "patched-fonts/FiraCode"
git sparse-checkout init
./install.sh FiraCode

popd || exit
