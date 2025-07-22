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
  "Lazygit|lazygit"
  "OpenCode AI Assistant|opencode"
  "Jump to Project|tmux-jump"
  "Lazydocker|lazydocker"
)

# Use fzf to create a searchable menu (no height limit since we're in a popup)
selected=$(
  printf "%s\n" "${commands[@]}" \
  | cut -d'|' -f1 \
  | fzf --border --reverse --prompt="Command Palette > " --header="Select a command to run in a new window"
)

# Exit if nothing was selected
if [[ -z "$selected" ]]; then
  exit 0
fi

# Find the matching command
for cmd in "${commands[@]}"; do
  description=$(echo "$cmd" | cut -d'|' -f1)
  if [[ "$description" == "$selected" ]]; then
    command_to_run=$(echo "$cmd" | cut -d'|' -f2)

    # Get the current pane's working directory
    current_path=$(tmux display-message -p "#{pane_current_path}")

    # Create a new window and execute the command
    tmux new-window -c "$current_path" "$command_to_run"
    break
  fi
done
