#!/usr/bin/env bash

#######################################################################
# script to quickly and easily create and jump between zellij sessions
#
# needed plugins: fzf, zoxide, zellij
#######################################################################

get_session_indentifier() {
  # map path to session identifier
  path="$1"
  directory=$(basename "$path")
  if [[ -z "$path" ]]; then
    exit
  fi

  # replace characters for easier identification
  echo "$directory" | tr ".:" "-"
}

create_session() {
  session="$1"
  path="$2"

  echo "Create \"$session\" session"
  # zellij can not create sessions with a given path, so handle it in here
  pushd "$path" > /dev/null || exit
  zellij attach --create --create-background "$session"
  popd > /dev/null || exit
}

check_and_start() {
  path="$1"
  session=$(get_session_indentifier "$path")

  if ! (zellij list-sessions --short | grep --quiet "$session"); then
    create_session "$session" "$path"
  fi
}

# always init notes session
path=$(zoxide query "notes")
check_and_start "$path"

# always init dotfiles session
path=$(zoxide query "dotfiles")
check_and_start "$path"

if [[ "$#" -le 0 ]]; then
  # start interactive selection when no arguments are given
  path=$(zoxide query --interactive) || exit
  check_and_start "$path"
else
  # otherwise query path of given match
  path=$(zoxide query "$@") || exit
  check_and_start "$path"
fi

# context aware change to session
if [[ -z "$ZELLIJ" ]]; then
  # outside of zellij -> attach to session
  zellij attach "$session"
else
  # inside of zellij -> use internal session manager instead
  echo "Use internal session manager instead"
  zellij action launch-or-focus-plugin session-manager --floating
fi
