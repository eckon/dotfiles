#!/usr/bin/env bash

#############################################################
# list all available scripts
#
# these can be searched, filtered and executed through fzf
#############################################################

scripts_paths=("$HOME/Development/dotfiles/scripts")

script_list=""
for i in "${scripts_paths[@]}"; do
  localScripts=$(find "$i" -iname "*.sh")

  if [[ "$script_list" == "" ]]; then
    script_list="${localScripts}"
  else
    script_list="${scriptList}\n${localScripts}"
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
    --delimiter="/" --with-nth -1 \
    --preview "$preview_window {}" \
    --preview-window up
)

eval "$selected_script"
