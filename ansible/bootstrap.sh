#!/usr/bin/env bash

if ! [ -x "$(command -v ansible)" ]; then
  echo "[!] Ansible is not installed"
  exit 1
fi

SCRIPT_PATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
INVENTORY="$SCRIPT_PATH/hosts"
PLAYBOOK="$SCRIPT_PATH/roles.yml"

ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-become-pass
