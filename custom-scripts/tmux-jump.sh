#!/usr/bin/env bash

#######################################################################
# script to quickly and easily jump between tmux sessions and
# start different edge cases
#
# needed plugins: fzf, zoxide
#######################################################################

# always init scratch and dotfiles session
session="scratch"
if ! (tmux has-session -t "$session" 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s "$session" -d -c "$HOME/Development"
fi

session="dotfiles"
if ! (tmux has-session -t "$session" 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s "$session" -d -c "$HOME/Development/dotfiles"

  echo "  Start editor via \"vim\""
  tmux send-key -t "$session":1 'vim' C-m
fi

# select special edge cases when no arguments are given
if [[ "$#" -le 0 ]]; then
  selected=$(printf "frontend\nbackend" | fzf --height 10% --reverse)
  workRoot="$HOME/Development/work"

  if [[ "$selected" == "backend" ]]; then
    session="idss"
    if ! (tmux has-session -t "$session" 2>/dev/null); then
      echo "Create \"$session\" session"
      tmux new-session -s "$session" -d -c "$workRoot/idss-shared-resources"

      echo "  Start services via \"docker-compose up\""
      tmux send-key -t "$session":1 'docker-compose up' C-m
    fi
  fi

  if [[ "$selected" == "frontend" ]]; then
    session="orchestrator"
    if ! (tmux has-session -t "$session" 2>/dev/null); then
      echo "Create \"$session\" session"
      tmux new-session -s "$session" -d -c "$workRoot/epos_fe.spa-orchestrator"

      echo "  Start services via \"npm run serve\""
      tmux send-key -t "$session":1 'npm run serve' C-m
    fi
  fi

  exit
fi

# get result of zoxide and create/attach to returning session
# exit if we get no result from zoxide
path=$(zoxide query "$@")
directory=$(basename "$path")
if [[ -z "$path" ]]; then
  exit
fi

# replace characters that tmux session names do not allow
session=$(echo "$directory" | tr ".:" "-")
if ! (tmux has-session -t "$session" 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s "$session" -d -c "$path"
fi


if [[ -z "$TMUX" ]];then
  # outside of tmux -> attach to session
  tmux attach -t "$session"
else
  # inside of tmux -> switch to another session
  tmux switch -t "$session"
fi
