#!/usr/bin/env bash

################################################################
# script to interactively create and jump between tmux sessions
#
# needed plugins: fzf, zoxide, tmux
################################################################

get_session_indentifier () {
  # map path to session identifier
  path="$1"
  directory=$(basename "$path")
  if [[ -z "$path" ]]; then
    exit
  fi

  # replace characters that tmux session names do not allow
  echo "$directory" | tr ".:" "-"
}

path=$(zoxide query --interactive) || exit
session=$(get_session_indentifier "$path")
if ! (tmux has-session -t "$session" 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s "$session" -d -c "$path"
fi

# context aware change to session
if [[ -z "$TMUX" ]];then
  # outside of tmux -> attach to session
  tmux attach -t "$session"
else
  # inside of tmux -> switch to another session
  tmux switch -t "$session"
fi
