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

# Commands shown in the palette, listed exactly as they are displayed
# Format: "Title | Context | Command", the command is everything after the last "|"
commands=(
  "claude     | AI Assistant           | claude"
  "opencode   | AI Assistant           | opencode"
  "pi         | AI Assistant           | pi"
  "K9s        | Kubernetes readonly    | k9s"
  "K9s        | Kubernetes destructive | k9s --write"
  "lazydocker | Docker TUI             | lazydocker"
  "lazygit    | Git TUI                | lazygit"
  "rider      | Dotnet IDE             | rider ."
  "Todos                               | todo"
)

# If a command is passed as an argument, run it directly
if [[ -n "$1" ]]; then
  selected="$1"
else
  # Use fzf to create a searchable menu (no height limit since we're in a popup)
  selected=$(
    printf "%s\n" "${commands[@]}" \
      | fzf --border --reverse --prompt="Command Palette > " --header="Select a command to run in a new window" \
      | sed 's/.*|[[:space:]]*//'
  )
fi

# Exit if nothing was selected
if [[ -z "$selected" ]]; then
  exit 0
fi

# Use the first word of the command as the window name
window_name="${selected%% *}"

tmux new-window -n "$window_name" -c "#{pane_current_path}" "$selected"
