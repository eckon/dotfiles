#!/usr/bin/env bash

#############################################################
# list all available scripts
#
# these can be searched, filtered and executed through fzf
#############################################################

scriptsPaths=(
  "$HOME/Development/dotfiles/custom-scripts"
)

scriptList=""
for i in "${scriptsPaths[@]}"; do
  localScripts=$(find "$i" -iname "*.sh")

  if [[ "$scriptList" == "" ]]; then
    scriptList="${localScripts}"
  else
    scriptList="${scriptList}\n${localScripts}"
  fi
done

# use cat in case we do not have bat for colors
previewWindow="cat"
if [ -x "$(command -v bat)" ]; then
  previewWindow="bat"
fi

# only show the last part of the path (-1)
selectedScript=$(
  printf "%s" "$scriptList" | fzf \
    --delimiter="/" --with-nth -1 \
    --preview "$previewWindow {}" \
    --preview-window up
)

eval "$selectedScript"
