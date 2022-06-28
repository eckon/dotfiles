#!/usr/bin/env bash

#################################
# script to install all packages
#################################

echo ""
echo "Install basic packages"
echo "----------------------"

sudo apt install -y \
  automake \
  bash \
  bison \
  build-essential \
  curl \
  entr \
  fonts-firacode \
  git \
  jq \
  libevent-dev \
  libncurses5-dev \
  libncursesw5-dev \
  moreutils \
  ripgrep \
  shellcheck \
  silversearcher-ag \
  tldr \
  tree \
  watchman \
  wget \
  xclip \
  zsh


echo ""
echo "Install basic packages with edgecases"
echo "-------------------------------------"

# install location for these special packages
binLocation="$HOME/.local/bin"
mkdir -p "$binLocation"

if ! command -v "bat" &> /dev/null; then
  echo "[+] Install \"bat\""
  sudo apt install -y bat
  ln -sf "$(which batcat)" "$binLocation/bat"
fi

if ! command -v "fd" &> /dev/null; then
  echo "[+] Install \"fd\""
  sudo apt install -y fd-find
  ln -sf "$(which fdfind)" "$binLocation/fd"
fi

if ! command -v "zoxide" &> /dev/null; then
  echo "[+] Install \"zoxide\""
  curl -sS https://webinstall.dev/zoxide | bash
fi

if ! command -v "fzf" &> /dev/null; then
  echo "[+] Install \"fzf\""
  git clone --depth 1 "https://github.com/junegunn/fzf.git" "$HOME/.fzf"
  ~/.fzf/install --all
fi

if ! command -v "tmux" &> /dev/null; then
  echo "[+] Install \"tmux\""
  git clone "https://github.com/tmux/tmux.git" "$HOME/.tmux"

  pushd "$HOME/.tmux" || exit
  sh "autogen.sh"
  ./configure && make
  sudo make install
  popd || exit
fi


echo ""
echo "Install git specific packages"
echo "-----------------------------"

if ! command -v "lazygit" &> /dev/null; then
  echo "[+] Install \"lazygit\""
  mkdir -p "/tmp/lazygit"

  wget -O "/tmp/lazygit/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz"

  tar xf "/tmp/lazygit/lazygit.tar.gz" --directory="/tmp/lazygit"
  cp "/tmp/lazygit/lazygit" "$binLocation"
fi

if ! command -v "delta" &> /dev/null; then
  echo "[+] Install \"delta\""
  mkdir -p "/tmp/delta"

  wget -O "/tmp/delta/delta.tar.gz" \
    "https://github.com/dandavison/delta/releases/download/0.13.0/delta-0.13.0-x86_64-unknown-linux-gnu.tar.gz"

  tar xf "/tmp/delta/delta.tar.gz" --directory="/tmp/delta"
  cp "/tmp/delta/delta-0.13.0-x86_64-unknown-linux-gnu/delta" "$binLocation"
fi


echo ""
echo "Install vim specific packages"
echo "-----------------------------"

if ! command -v "nvim" &> /dev/null; then
  echo "[+] Install \"nvim\""
  mkdir -p "/tmp/neovim"

  wget -O "/tmp/neovim/nvim.appimage" \
    "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"

  chmod +x "/tmp/neovim/nvim.appimage"
  cp "/tmp/neovim/nvim.appimage" "$binLocation/nvim"
fi

vimPlugLocation="$HOME/.local/share/nvim/site/autoload/plug.vim"
if ! test -f "$vimPlugLocation"; then
  echo "[+] Install \"vim-plug\""
  curl -fLo "$vimPlugLocation" --create-dirs \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi


echo ""
echo "Install node specific packages"
echo "------------------------------"

if ! command -v "fnm" &> /dev/null; then
  echo "[+] Install \"fnm\""
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

  eval "$(fnm env)"
  fnm use 16 --install-if-missing
  fnm default "$(node --version)"
fi


echo ""
echo "Install terminal specific packages"
echo "----------------------------------"

if ! command -v "fish" &> /dev/null; then
  echo "[+] Install \"fish\""
  sudo apt-add-repository ppa:fish-shell/release-3 -y
  sudo apt update -y
  sudo apt install fish -y

  shellsPath="/etc/shells"
  fishPath=$(which fish)
  grep -qxF "$fishPath" "$shellsPath" || \
    (echo "$fishPath" | sudo tee -a "$shellsPath")

  chsh -s "$fishPath"
fi

if ! command -v "kitty" &> /dev/null; then
  echo "[+] Install \"kitty\""
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  ln -sfn "$HOME/.local/kitty.app/bin/kitty" "$binLocation"

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

if ! command -v "starship" &> /dev/null; then
  echo "[+] Install \"starship\""
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
