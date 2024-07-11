#!/usr/bin/env bash

#################################################################
# script to start predefined sessions in tmux from the ground up
#
# needed plugins: fzf, zoxide, tmux
#################################################################

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

if [[ "$#" -ge 1 ]]; then
  echo "No arguments allowed"
  exit
fi

# pool of selectable sessions that can be created
declare -a PREDEFINED_SESSIONS
PREDEFINED_SESSIONS=(
  "backend"
  "frontend"
)

option_string=""
for index in "${!PREDEFINED_SESSIONS[@]}"; do
  option_string="${PREDEFINED_SESSIONS[$index]}\n$option_string"
done

selected=$(printf "$option_string" | fzf --height 10% --reverse)

if [[ "$selected" == "backend" ]]; then
  path=$(zoxide query "idss")
  session=$(get_session_indentifier "$path")
  if ! (tmux has-session -t "$session" 2> /dev/null); then
    echo "Create \"$session\" session"
    tmux new-session -s "$session" -d -c "$path"

    echo "  Start services via \"docker compose up\""
    tmux send-key -t "$session":1 'docker compose up' C-m
  fi

  exit
fi

if [[ "$selected" == "frontend" ]]; then
  path=$(zoxide query "orchestrator")
  session=$(get_session_indentifier "$path")
  if ! (tmux has-session -t "$session" 2> /dev/null); then
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
  if ! (tmux has-session -t "$session" 2> /dev/null); then
    echo "Create \"$session\" session"
    tmux new-session -s "$session" -d -c "$path"

    echo "  Start editor via \"vim\""
    tmux send-key -t "$session":1 'vim .env' C-m
    tmux split-window -t "$session":1 -h -c "$path"

    echo "  Start services via \"npm run dev\""
    tmux send-key -t "$session":1 'npm run dev' C-m
    tmux select-pane -L -t "$session":1
  fi

  exit
fi

echo "Case \"$selected\" has no dedicated implementation and therefore was not created"
