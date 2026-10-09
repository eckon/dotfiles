#!/usr/bin/env bash
# shellcheck disable=SC2046 # `$(: "...")` is used as inline comment for packages

set -euo pipefail

if ! command -v yay &> /dev/null; then
  echo "yay is not installed"
  exit 1
fi

yay -S --noconfirm --needed \
  bat $(: "cat enhancement with syntax highlighting") \
  btop $(: "system monitor") \
  chromium \
  docker \
  dust $(: "du replacement with better visualization") \
  eza $(: "pretty ls") \
  fd $(: "find replacement, faster and easier to use") \
  firefox \
  fish $(: "friendly interactive shell") \
  flameshot $(: "screenshot tool") \
  fzf $(: "fuzzy finder") \
  ghostty $(: "terminal emulator") \
  git \
  git-delta $(: "git diff enhancement") \
  difftastic $(: "structural syntax aware diff") \
  grim $(: "as a dependency for screenshot tools like flameshot") \
  hyprland $(: "wayland compositor") \
  hyprpolkitagent $(: "polkit agent") \
  jq $(: "json processor") \
  k9s $(: "kubernetes TUI") \
  kubectl \
  lazydocker $(: "TUI for docker") \
  lazygit $(: "TUI for git") \
  localsend-bin $(: "local file sharing") \
  mise $(: "dev tool version manager, task runner, env manager") \
  noctalia $(: "desktop shell, bar, launcher and notifications") \
  nvtop $(: "nvidia GPU monitor") \
  opencode-bin $(: "AI coding agent") \
  ripgrep $(: "grep replacement") \
  sesh-bin $(: "tmux session manager, replacement for my tmux-jump script") \
  starship $(: "shell prompt") \
  tealdeer $(: "simplified man pages, its tldr") \
  tmux $(: "terminal multiplexer") \
  tree-sitter-cli $(: "parsing tool for syntax highlighting") \
  ttf-firacode-nerd $(: "nerd font with icon support") \
  usage $(: "cli spec tool, used by mise for task args and completions") \
  wl-clipboard $(: "wayland clipboard utilities") \
  workmux-bin $(: "git worktree tool") \
  xdg-desktop-portal $(: "dependency for things like flameshot") \
  xdg-desktop-portal-hyprland $(: "dependency for things like flameshot") \
  zoxide $(: "smarter cd command")
