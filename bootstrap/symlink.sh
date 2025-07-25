#!/usr/bin/env bash

##################################################################
# script to symlink all my local configurations and scripts
# relies on being executed in the correct context (root dotfiles)
##################################################################

declare -A CONFIG_PATHS
CONFIG_PATHS=(
  ["config/alacritty.yml"]=".config/alacritty.yml"
  ["config/fish/config.fish"]=".config/fish/config.fish"
  ["config/git"]=".config/git"
  ["config/helix/config.toml"]=".config/helix/config.toml"
  ["config/jetbrains/ideavimrc"]=".config/ideavim/ideavimrc"
  ["config/k9s"]=".config/k9s"
  ["config/kitty/kitty.conf"]=".config/kitty/kitty.conf"
  ["config/lazydocker/config.yml"]=".config/lazydocker/config.yml"
  ["config/lazygit/config.yml"]=".config/lazygit/config.yml"
  ["config/nvim"]=".config/nvim"
  ["config/opencode/opencode.json"]=".config/opencode/opencode.json"
  ["config/ripgreprc"]=".config/ripgreprc"
  ["config/starship.toml"]=".config/starship.toml"
  ["config/tmux"]=".config/tmux"
  ["config/vscode/keybindings.json"]=".config/Code/User/keybindings.json"
  ["config/vscode/settings.json"]=".config/Code/User/settings.json"
  ["config/zellij/config.kdl"]=".config/zellij/config.kdl"
  ["config/zshrc"]=".zshrc"
)

if [ -f "/proc/version" ] && cat "/proc/version" | grep --ignore-case "wsl" -q; then
  # vscode in wsl will create an additional config file, link it
  # some settings can not be linked like this and need to be put into user file (check vscode for info)
  CONFIG_PATHS+=(
    ["config/vscode/keybindings.json"]=".vscode-server/data/Machine/keybindings.json"
    ["config/vscode/settings.json"]=".vscode-server/data/Machine/settings.json"
  )
fi

declare -A SCRIPT_PATHS
SCRIPT_PATHS=(
  ["git-tmp-copy.sh"]="git-tmp-copy"
  ["tmux-command-palette.sh"]="tmux-command-palette"
  ["tmux-jump.sh"]="tmux-jump"
  ["tmux-jumpstart.sh"]="tmux-jumpstart"
  ["zellij-jump.sh"]="zellij-jump"
)

echo ""
echo "Symlink configurations"
echo "----------------------"

for config_path in "${!CONFIG_PATHS[@]}"; do
  target_path=${CONFIG_PATHS[$config_path]}
  from_path="$(pwd)/$config_path"
  to_path="$HOME/$target_path"

  if ! test -e "$from_path"; then
    echo "[!] Path \"$from_path\" does not exist -> exit script"
    exit
  fi

  parent_dir=$(dirname "$to_path")
  if ! test -d "$parent_dir"; then
    printf "[+] Create directory: %s\n" "$parent_dir"
    mkdir -p "$parent_dir"
  fi

  # ignore if already symlinked
  if [ ! -L "$to_path" ]; then
    printf "[+] Create Symlink (config): %-20s -> \"%s\"\n" "$(basename "$from_path")" "$to_path"
    ln -sfn "$from_path" "$to_path"
  fi
done

echo ""
echo "Symlink custom scripts"
echo "----------------------"

for path in "${!SCRIPT_PATHS[@]}"; do
  scriptName=${SCRIPT_PATHS[$path]}
  from_path="$(pwd)/scripts/$path"
  to_path="$HOME/.local/bin/$scriptName"

  if ! test -e "$from_path"; then
    echo "[!] Path \"$from_path\" does not exist -> exit script"
    exit
  fi

  parent_dir=$(dirname "$to_path")
  if ! test -d "$parent_dir"; then
    printf "[+] Create directory: %s\n" "$parent_dir"
    mkdir -p "$parent_dir"
  fi

  # ignore if already symlinked
  if [ ! -L "$to_path" ]; then
    printf "[+] Create Symlink (script): %-20s -> \"%s\"\n" "$path" "$to_path"
    ln -sf "$from_path" "$to_path"
  fi
done
