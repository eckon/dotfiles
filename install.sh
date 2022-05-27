#!/usr/bin/env bash

###################################
# script to call all setup scripts
###################################

if [[ $(basename "$(pwd)") != "dotfiles" ]]; then
  echo "This script can only be run in the \"dotfiles\" folder"
  exit 1
fi

./custom-scripts/setup/symlink.sh
./custom-scripts/setup/install-packages.sh
