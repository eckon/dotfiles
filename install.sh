#!/usr/bin/env bash

###################################
# script to call all setup scripts
###################################

if [[ $(basename "$(pwd)") != "dotfiles" ]]; then
  echo "This script can only be run in the \"dotfiles\" folder"
  exit
fi

# cache sudo password for later processes which require it,
# and to ignore the whole process in case a wrong password was provided
sudo -v || exit

./custom-scripts/setup/symlink.sh
./custom-scripts/setup/install-packages.sh
