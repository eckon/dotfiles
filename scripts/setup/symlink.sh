#!/usr/bin/env bash

##################################################################
# script to symlink all my local configurations and scripts
# relies on being executed in the correct context (root dotfiles)
##################################################################

declare -A configPaths
configPaths=(
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
  ["config/starship.toml"]=".config/starship.toml"
  ["config/tmux"]=".config/tmux"
  ["zshrc"]=".zshrc"
)

declare -A scriptPaths
scriptPaths=(
  ["tmux-jump.sh"]="tmux-jump"
  ["git-tmp-copy.sh"]="git-tmp-copy"
)


echo ""
echo "Symlink configurations"
echo "----------------------"

for configPath in "${!configPaths[@]}"; do
  targetPath=${configPaths[$configPath]}
  fromPath="$(pwd)/$configPath"
  toPath="$HOME/$targetPath"

  if ! test -e "$fromPath"; then
    echo "[!] Path \"$fromPath\" does not exist -> exit script"
    exit
  fi

  parentDirectory=$(dirname "$toPath")
  if ! test -d "$parentDirectory"; then
    printf "[+] Create directory: %s\n" "$parentDirectory"
    mkdir -p "$parentDirectory"
  fi

  # ignore if already symlinked
  if [ ! -L "$toPath" ]; then
    printf "[+] Create Symlink (config): %-20s -> \"%s\"\n" "$(basename "$fromPath")" "$toPath"
    ln -sfn "$fromPath" "$toPath"
  fi
done


echo ""
echo "Symlink custom scripts"
echo "----------------------"

for path in "${!scriptPaths[@]}"; do
  scriptName=${scriptPaths[$path]}
  fromPath="$(pwd)/scripts/$path"
  toPath="$HOME/.local/bin/$scriptName"

  if ! test -e "$fromPath"; then
    echo "[!] Path \"$fromPath\" does not exist -> exit script"
    exit
  fi

  parentDirectory=$(dirname "$toPath")
  if ! test -d "$parentDirectory"; then
    printf "[+] Create directory: %s\n" "$parentDirectory"
    mkdir -p "$parentDirectory"
  fi

  # ignore if already symlinked
  if [ ! -L "$toPath" ]; then
    printf "[+] Create Symlink (script): %-20s -> \"%s\"\n" "$path" "$toPath"
    ln -sf "$fromPath" "$toPath"
  fi
done
