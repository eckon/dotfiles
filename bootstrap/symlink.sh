#!/usr/bin/env bash

##################################################################
# script to symlink all my local configurations and scripts
#
# usage: ./symlink.sh [--dry-run]
##################################################################

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$SCRIPT_DIR")"

declare -A CONFIG_PATHS
CONFIG_PATHS=(
  ["config/agents"]=".agents"
  ["config/fish/config.fish"]=".config/fish/config.fish"
  ["config/fish/custom"]=".config/fish/custom"
  ["config/ghostty"]=".config/ghostty"
  ["config/git"]=".config/git"
  ["config/herdr/config.toml"]=".config/herdr/config.toml"
  ["config/hypr"]=".config/hypr"
  ["config/jetbrains/ideavimrc"]=".config/ideavim/ideavimrc"
  ["config/k9s"]=".config/k9s"
  ["config/kitty/kitty.conf"]=".config/kitty/kitty.conf"
  ["config/lazydocker/config.yml"]=".config/lazydocker/config.yml"
  ["config/lazygit/config.yml"]=".config/lazygit/config.yml"
  ["config/mise"]=".config/mise"
  ["config/niri"]=".config/niri"
  ["config/noctalia"]=".config/noctalia"
  ["config/nvim"]=".config/nvim"
  ["config/opencode"]=".config/opencode"
  ["config/pi/AGENTS.md"]=".pi/agent/AGENTS.md"
  ["config/pi/extensions"]=".pi/agent/extensions"
  ["config/pi/keybindings.json"]=".pi/agent/keybindings.json"
  ["config/ripgreprc"]=".config/ripgreprc"
  ["config/starship.toml"]=".config/starship.toml"
  ["config/tmux"]=".config/tmux"
  ["config/vscode/keybindings.json"]=".config/Code/User/keybindings.json"
  ["config/vscode/settings.json"]=".config/Code/User/settings.json"
  ["config/waybar"]=".config/waybar"
  ["config/zellij/config.kdl"]=".config/zellij/config.kdl"
)

if [ -f "/proc/version" ] && grep --ignore-case --quiet "wsl" "/proc/version"; then
  # vscode in wsl will create an additional config file, link it
  # some settings can not be linked like this and need to be put into user file (check vscode for info)
  CONFIG_PATHS+=(
    ["config/vscode/keybindings.json"]=".vscode-server/data/Machine/keybindings.json"
    ["config/vscode/settings.json"]=".vscode-server/data/Machine/settings.json"
  )
fi

declare -A SCRIPT_PATHS
SCRIPT_PATHS=(
  ["tmux-command-palette.sh"]="tmux-command-palette"
  ["tmux-jump.sh"]="tmux-jump"
)

DRY_RUN="false"
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN="true"
fi

CONFLICTS=0

link_path() {
  local label="$1" from_path="$2" to_path="$3"

  if ! test -e "$from_path"; then
    echo "[!] Path \"$from_path\" does not exist -> exit script"
    exit 1
  fi

  # already pointing at the right place, a stale link is repointed below
  if [ -L "$to_path" ] && [ "$(readlink "$to_path")" = "$from_path" ]; then
    return
  fi

  # a real file or directory here belongs to something else, report instead of deleting it
  if [ -e "$to_path" ] && [ ! -L "$to_path" ]; then
    printf "[!] Conflict (%s): \"%s\" exists and is not a symlink\n" "$label" "$to_path"
    CONFLICTS=$((CONFLICTS + 1))
    return
  fi

  printf "[+] Create symlink (%s): %-20s -> \"%s\"\n" "$label" "$(basename "$from_path")" "$to_path"

  if [ "$DRY_RUN" = "false" ]; then
    mkdir -p "$(dirname "$to_path")"
    ln -sfn "$from_path" "$to_path"
  fi
}

for config_path in "${!CONFIG_PATHS[@]}"; do
  link_path "config" "$DOTFILES_ROOT/$config_path" "$HOME/${CONFIG_PATHS[$config_path]}"
done

for script_path in "${!SCRIPT_PATHS[@]}"; do
  link_path "script" "$DOTFILES_ROOT/scripts/$script_path" "$HOME/.local/bin/${SCRIPT_PATHS[$script_path]}"
done

if [ "$CONFLICTS" -gt 0 ]; then
  echo "[!] Resolve the conflicts above by moving or deleting those paths yourself"
  exit 1
fi
