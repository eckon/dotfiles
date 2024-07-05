#!/usr/bin/env bash

#########################################################################
# script to quickly and easily create and jump between tmux sessions and
# start different edge cases
#
# needed plugins: fzf, zoxide, tmux
#########################################################################

get_session_indentifier() {
  # map path to session identifier
  path="$1"
  directory=$(basename "$path")
  if [[ -z "$path" ]]; then
    exit
  fi

  # replace characters that tmux session names do not allow
  echo "$directory" | tr ".:" "-"
}

if [[ "$#" -le 0 ]]; then
  # start interactive selection when no arguments are given
  path=$(zoxide query --interactive) || exit
  session=$(get_session_indentifier "$path")
  if ! (tmux has-session -t "$session" 2> /dev/null); then
    echo "Create \"$session\" session"
    tmux new-session -s "$session" -d -c "$path"
  fi
else
  # otherwise query path of given match
  path=$(zoxide query "$@") || exit
  session=$(get_session_indentifier "$path")
  if ! (tmux has-session -t "$session" 2> /dev/null); then
    echo "Create \"$session\" session"
    tmux new-session -s "$session" -d -c "$path"
  fi
fi

# context aware change to session
if [[ -z "$TMUX" ]]; then
  # outside of tmux -> attach to session
  tmux attach -t "$session"
else
  # inside of tmux -> switch to another session
  tmux switch -t "$session"
fi
