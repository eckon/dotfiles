#!/usr/bin/env bash

set -euo pipefail

if ! command -v apt &> /dev/null; then
  echo "apt is not installed"
  exit 1
fi

sudo apt install -y \
  build-essential \
  cmake \
  curl \
  file \
  git \
  procps
