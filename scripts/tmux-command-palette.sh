#!/usr/bin/env bash

#########################################################################
# Script to provide a VSCode-like command palette for tmux
# Allows searching and executing predefined commands in a new tmux window
# Designed to run in a tmux popup
#
# Usage:
#   tmux-command-palette           - open fzf picker
#   tmux-command-palette <cmd>     - run a specific command directly (e.g. "lazygit")
#
# Dependencies: fzf
#########################################################################

# check dependencies
if ! command -v fzf &> /dev/null; then
  echo "Error: fzf is required but not installed"
  exit 1
fi

# Define commands with their descriptions and actions
# Format: "Description|Command to execute"
commands=(
  "AI Assistant (opencode)|opencode"
  "AI Assistant (pi)|pi"
  "Docker TUI|lazydocker"
  "Git TUI|lazygit"
  "Open rider|rider ."
  "Todos|todo"
)

# If a command is passed as an argument, find and run it directly
if [[ -n "$1" ]]; then
  selected="$1"
else
  # Use fzf to create a searchable menu (no height limit since we're in a popup)
  selected=$(
    printf "%s\n" "${commands[@]}" \
      | awk -F'|' '{ printf "%-30s | %s\n", $1, $2 }' \
      | fzf --border --reverse --prompt="Command Palette > " --header="Select a command to run in a new window" \
      | awk -F'|' '{ print $2 }' \
      | sed 's/^[[:space:]]*//'
  )
fi

# Exit if nothing was selected
if [[ -z "$selected" ]]; then
  exit 0
fi

# Use the first word of the command as the window name
window_name="${selected%% *}"

tmux new-window -n "$window_name" -c "#{pane_current_path}" "$selected"
