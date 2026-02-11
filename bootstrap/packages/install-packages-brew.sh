#!/usr/bin/env bash

set -euo pipefail

brew tap jesseduffield/lazydocker
brew tap jesseduffield/lazygit
brew tap anomalyco/tap

brew install \
  anomalyco/tap/opencode \
  bash \
  bat                                  $(: "cat enhancement") \
  cmake \
  curl \
  eza                                  $(: "ls alternative") \
  fd                                   $(: "find replacement") \
  fish \
  fzf \
  gettext \
  git \
  git-crypt \
  git-delta                            $(: "git diff enhancement") \
  jesseduffield/lazydocker/lazydocker \
  jesseduffield/lazygit/lazygit \
  jq \
  k9s \
  kubectl \
  mise                                 $(: "dev tool version manager, task runner, env manager") \
  ninja                                $(: "build system") \
  ripgrep                              $(: "grep replacement") \
  selene                               $(: "lua linter") \
  shellcheck \
  starship \
  tldr \
  tmux \
  tree-sitter-cli \
  uv                                   $(: "python package manager") \
  zellij \
  zoxide
