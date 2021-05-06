#!/usr/bin/env bash

plugins=(
  "bmewburn.vscode-intelephense-client"
  "coenraads.disableligatures"
  "eamodio.gitlens"
  "ms-azuretools.vscode-docker"
  "vscodevim.vim"
  "xadillax.viml"
  "yzhang.markdown-all-in-one"
)

for element in "${plugins[@]}"; do
  echo "[!] Install \"$element\" plugin."
  code --install-extension "$element"
done
