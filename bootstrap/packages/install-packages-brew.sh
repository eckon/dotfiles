#!/usr/bin/env bash
# shellcheck disable=SC2046 # `$(: "...")` is used as inline comment for packages

set -euo pipefail

if ! command -v brew &> /dev/null; then
  echo "brew is not installed"
  exit 1
fi

brew install \
  bash \
  bat $(: "cat enhancement") \
  cmake \
  curl \
  dust $(: "du replacement with better visualization") \
  eza $(: "ls alternative") \
  fd $(: "find replacement") \
  fish \
  fzf \
  gettext \
  git \
  git-crypt \
  git-delta $(: "git diff enhancement") \
  jq \
  k9s \
  kubectl \
  lazydocker \
  lazygit \
  mise $(: "dev tool version manager, task runner, env manager") \
  ninja $(: "build system") \
  opencode \
  raine/workmux/workmux $(: "git worktree tool") \
  ripgrep $(: "grep replacement") \
  sesh $(: "tmux session manager, replacement for my tmux-jump script") \
  starship \
  tldr \
  tmux \
  tree-sitter-cli \
  zellij \
  zoxide
