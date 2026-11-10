#!/usr/bin/env bash

#########################################################################
# Script to provide a VSCode-like command palette for tmux
# Allows searching and executing predefined commands in a new tmux window
# Designed to run in a tmux popup
#
# Dependencies: fzf
#########################################################################

# check dependencies
if ! command -v fzf &> /dev/null; then
  echo "Error: fzf is required but not installed"
  exit 1
fi

# Commands shown in the palette, listed exactly as they are displayed
# Format: "Title | Context | Command", the command is everything after the last "|"
commands=(
  "claude     | AI Assistant           | claude"
  "opencode   | AI Assistant           | opencode"
  "lazydocker | Docker TUI             | lazydocker"
)

# Use fzf to create a searchable menu (no height limit since we're in a popup)
selected=$(
  printf "%s\n" "${commands[@]}" \
    | fzf --border --reverse --prompt="Command Palette > " --header="Select a command to run in a new window" \
    | sed 's/.*|[[:space:]]*//'
)

# Exit if nothing was selected
if [[ -z "$selected" ]]; then
  exit 0
fi

# Use the first word of the command as the window name
window_name="${selected%% *}"

tmux new-window -n "$window_name" -c "#{pane_current_path}" "$selected"
