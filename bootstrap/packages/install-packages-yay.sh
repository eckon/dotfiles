#!/usr/bin/env bash

set -euo pipefail

yay -S --noconfirm --needed \
  bat                      $(: "cat enhancement with syntax highlighting") \
  btop                     $(: "system monitor") \
  chromium \
  docker \
  dust                     $(: "du replacement with better visualization") \
  eza                      $(: "pretty ls") \
  fd                       $(: "find replacement, faster and easier to use") \
  firefox \
  fish                     $(: "friendly interactive shell") \
  flameshot                $(: "screenshot tool") \
  fzf                      $(: "fuzzy finder") \
  git \
  git-delta                $(: "git diff enhancement") \
  grim                     $(: "as a dependency for screenshot tools like flameshot") \
  hyprland                 $(: "wayland compositor") \
  hyprpolkitagent          $(: "polkit agent") \
  jq                       $(: "json processor") \
  k9s                      $(: "kubernetes TUI") \
  kitty                    $(: "terminal emulator") \
  kubectl \
  lazydocker               $(: "TUI for docker") \
  lazygit                  $(: "TUI for git") \
  localsend-bin            $(: "local file sharing") \
  mise                     $(: "dev tool version manager, task runner, env manager") \
  nvtop                    $(: "nvidia GPU monitor") \
  opencode-bin             $(: "AI coding assistant") \
  selene                   $(: "lua linter") \
  shellcheck               $(: "shell script linter") \
  starship                 $(: "shell prompt") \
  tealdeer                 $(: "simplified man pages, its tldr") \
  tmux                     $(: "terminal multiplexer") \
  tree-sitter-cli          $(: "parsing tool for syntax highlighting") \
  ttf-firacode-nerd        $(: "nerd font with icon support") \
  usage                    $(: "monitor command usage") \
  uv                       $(: "python package manager") \
  wl-clipboard             $(: "wayland clipboard utilities") \
  xdg-desktop-portal-hyprland \
  zoxide                   $(: "smarter cd command")
