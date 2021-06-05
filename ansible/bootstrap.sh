#!/usr/bin/env bash

if ! [ -x "$(command -v ansible)" ]; then
  echo "[!] Ansible is not installed"
  exit 1
fi

SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
INVENTORY="$SCRIPT_PATH/hosts"
PLAYBOOK="$SCRIPT_PATH/playbook.yml"

if [[ $# -gt 0 ]]; then
  ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --list-tags

  TAGS_SPACE_SEPARATED="$@"
  TAGS="${TAGS_SPACE_SEPARATED// /,}"

  echo -e "\n\nCall playbook with tags: $TAGS\n"
  echo "Press any key to continue"
  read -r -s -n 1

  ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-become-pass --tags "$TAGS"
  exit 0
fi

ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-become-pass
