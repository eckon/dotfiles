#!/usr/bin/env bash

#################################
# script to install all packages
#################################

sudo apt update
sudo apt upgrade

sudo apt install -y \
  autoconf \
  automake \
  bash \
  bison \
  build-essential \
  curl \
  entr \
  libevent-dev \
  libfuse2 \
  libncurses5-dev \
  libncursesw5-dev \
  moreutils \
  pkg-config \
  unzip \
  watchman \
  wget \
  xclip \
  yad \
  zsh


if ! command -v "brew" &> /dev/null; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew install \
  bat \
  fd \
  fish \
  fnm \
  fzf \
  git \
  git-delta \
  jq \
  lazygit \
  ripgrep \
  shellcheck \
  starship \
  tldr \
  tmux \
  zoxide


# followup process for shell (fish) installation
if ! echo "$SHELL" | grep -qF "fish"; then
  echo "[+] Add fish as default shell"

  SHELLS_PATH="/etc/shells"
  FISH_PATH=$(which fish)
  grep -qxF "$FISH_PATH" "$SHELLS_PATH" || \
    (echo "$FISH_PATH" | sudo tee -a "$SHELLS_PATH")

  chsh -s "$FISH_PATH"
fi


# install location for these special packages
LOCAL_BIN_PATH="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN_PATH"

if ! command -v "nvim" &> /dev/null; then
  echo "[+] Install \"nvim\""
  mkdir -p "/tmp/neovim"

  wget -O "/tmp/neovim/nvim.appimage" \
    "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"

  chmod +x "/tmp/neovim/nvim.appimage"
  cp "/tmp/neovim/nvim.appimage" "$LOCAL_BIN_PATH/nvim"
fi

if command -v "fc-list" &> /dev/null && ! (fc-list | grep -qF "FiraCode Nerd Font"); then
  echo "[+] Install \"Patched FiraCode\" via \"Nerdfonts\""

  # nerdfont is gigantic, only clone minimum (only root)
  git clone --depth 1 --filter=blob:none --sparse \
    "https://github.com/ryanoasis/nerd-fonts.git" \
    "$HOME/.nerdfonts"

  pushd "$HOME/.nerdfonts" || exit

  # afterwards use sparse-checkout to furthermore only pull FiraCode
  git sparse-checkout add "patched-fonts/FiraCode"
  git sparse-checkout init
  ./install.sh FiraCode

  popd || exit
fi

# WSL does not need kitty, as it has its own terminal emulator
if cat "/proc/version" | grep -qiF "wsl"; then
  echo "[!] Early exit - currently in WSL"
  exit
fi

if ! command -v "kitty" &> /dev/null; then
  echo "[+] Install \"kitty\""
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  ln -sfn "$HOME/.local/kitty.app/bin/kitty" "$LOCAL_BIN_PATH"

  mkdir -p "$HOME/.local/share/applications"
  cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications"
  cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications"

  sed -i \
    "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
    "$HOME/.local/share/applications/kitty.desktop"

  sed -i \
    "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" \
    "$HOME/.local/share/applications/kitty.desktop"
fi
