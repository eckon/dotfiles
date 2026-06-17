#!/usr/bin/env bash

set -euo pipefail

if ! command -v dnf &> /dev/null; then
  echo "dnf is not installed"
  exit 1
fi

sudo dnf install -y \
  gcc
