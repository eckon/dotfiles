#!/usr/bin/env bash

#########################################################################
# Script to provide a VSCode-like command palette for tmux
# Allows searching and executing predefined commands in a new tmux window
# Designed to run in a tmux popup
#
# Dependencies: fzf
#########################################################################

# Define commands with their descriptions and actions
# Format: "Description|Command to execute"
commands=(
  "AI Assistant|opencode"
  "Docker TUI|lazydocker"
  "Git TUI|lazygit"
  "Jump to Project|tmux-jump"
)

# Use fzf to create a searchable menu (no height limit since we're in a popup)
selected=$(
  printf "%s\n" "${commands[@]}" \
    | awk -F'|' '{ printf "%-30s %s\n", $1, $2 }' \
    | fzf --border --reverse --prompt="Command Palette > " --header="Select a command to run in a new window" \
    | awk '{ print $NF }'
)

# Exit if nothing was selected
if [[ -z "$selected" ]]; then
  exit 0
fi

tmux new-window -c "#{pane_current_path}" "$selected"
