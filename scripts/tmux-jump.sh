#!/usr/bin/env bash

#########################################################################
# script to quickly and easily create and jump between tmux sessions and
# start different edge cases
#
# needed plugins: fzf, zoxide, tmux
#########################################################################

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

# always init notes session
path=$(zoxide query "notes")
session=$(get_session_indentifier "$path")
if ! (tmux has-session -t "$session" 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s "$session" -d -c "$path"

  echo "  Start editor via \"vim\""
  tmux send-key -t "$session":1 "vim README.md" C-m
fi

# always init dotfiles session
path=$(zoxide query "dotfiles")
session=$(get_session_indentifier "$path")
if ! (tmux has-session -t "$session" 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s "$session" -d -c "$path"

  echo "  Start editor via \"vim\""
  tmux send-key -t "$session":1 'vim' C-m
fi

# select special edge cases when no arguments are given
if [[ "$#" -le 0 ]]; then
  selected=$(printf "backend\nfrontend" | fzf --height 10% --reverse)

  if [[ "$selected" == "backend" ]]; then
    path=$(zoxide query "idss")
    session=$(get_session_indentifier "$path")
    if ! (tmux has-session -t "$session" 2>/dev/null); then
      echo "Create \"$session\" session"
      tmux new-session -s "$session" -d -c "$path"

      echo "  Start services via \"docker compose up\""
      tmux send-key -t "$session":1 'docker compose up' C-m
    fi
  fi

  if [[ "$selected" == "frontend" ]]; then
    path=$(zoxide query "orchestrator")
    session=$(get_session_indentifier "$path")
    if ! (tmux has-session -t "$session" 2>/dev/null); then
      echo "Create \"$session\" session"
      tmux new-session -s "$session" -d -c "$path"

      echo "  Start editor via \"vim\""
      tmux send-key -t "$session":1 'vim -o .local.js .env' C-m
      tmux split-window -t "$session":1 -h -c "$path"

      echo "  Start services via \"npm run dev\""
      tmux send-key -t "$session":1 'npm run dev' C-m
      tmux select-pane -L -t "$session":1
    fi

    path=$(zoxide query "core-applets")
    session=$(get_session_indentifier "$path")
    if ! (tmux has-session -t "$session" 2>/dev/null); then
      echo "Create \"$session\" session"
      tmux new-session -s "$session" -d -c "$path"

      echo "  Start editor via \"vim\""
      tmux send-key -t "$session":1 'vim .env' C-m
      tmux split-window -t "$session":1 -h -c "$path"

      echo "  Start services via \"npm run dev\""
      tmux send-key -t "$session":1 'npm run dev' C-m
      tmux select-pane -L -t "$session":1
    fi
  fi

  exit
fi

# query path of given match otherwise exit
path=$(zoxide query "$@") || exit
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
