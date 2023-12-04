#!/usr/bin/env bash

##################################################################
# script to symlink all my local configurations and scripts
# relies on being executed in the correct context (root dotfiles)
##################################################################

declare -A CONFIG_PATHS
CONFIG_PATHS=(
  ["config/Code/User/keybindings.json"]=".config/Code/User/keybindings.json"
  ["config/Code/User/settings.json"]=".config/Code/User/settings.json"
  ["config/alacritty.yml"]=".config/alacritty.yml"
  ["config/fish/config.fish"]=".config/fish/config.fish"
  ["config/git"]=".config/git"
  ["config/helix/config.toml"]=".config/helix/config.toml"
  ["config/ideavim/ideavimrc"]=".config/ideavim/ideavimrc"
  ["config/kitty/kitty.conf"]=".config/kitty/kitty.conf"
  ["config/lazygit/config.yml"]=".config/lazygit/config.yml"
  ["config/nvim"]=".config/nvim"
  ["config/ripgreprc"]=".config/ripgreprc"
  ["config/starship.toml"]=".config/starship.toml"
  ["config/tmux"]=".config/tmux"
  ["zshrc"]=".zshrc"
)

declare -A SCRIPT_PATHS
SCRIPT_PATHS=(
  ["tmux-jump.sh"]="tmux-jump"
  ["tmux-interactive-jump.sh"]="tmux-interactive-jump"
  ["git-tmp-copy.sh"]="git-tmp-copy"
)


echo ""
echo "Symlink configurations"
echo "----------------------"

for configPath in "${!CONFIG_PATHS[@]}"; do
  target_path=${CONFIG_PATHS[$configPath]}
  from_path="$(pwd)/$configPath"
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
