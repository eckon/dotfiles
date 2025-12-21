#!/usr/bin/env bash

#############################################################
# list all available scripts
#
# these can be searched, filtered and executed through fzf
#############################################################

# check dependencies
if ! command -v fzf &> /dev/null; then
  echo "Error: fzf is required but not installed"
  exit 1
fi

SCRIPTS_PATHS=("$HOME/Development/dotfiles/scripts")

script_list=""
for i in "${SCRIPTS_PATHS[@]}"; do
  local_scripts=$(find "$i" -iname "*.sh")

  if [[ "$script_list" == "" ]]; then
    script_list="${local_scripts}"
  else
    script_list="${script_list}\n${local_scripts}"
  fi
done

# use cat in case we do not have bat for colors
preview_window="cat"
if [ -x "$(command -v bat)" ]; then
  preview_window="bat"
fi

# only show the last part of the path (-1)
selected_script=$(
  printf "%s" "$script_list" | fzf \
    --ansi \
    --delimiter="/" --with-nth -1 \
    --preview "$preview_window --color=always {}" \
    --preview-window up
)

"$selected_script"
