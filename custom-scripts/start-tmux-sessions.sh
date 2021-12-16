#!/usr/bin/env bash

#######################################################################
# script to quickly open my tmux panes/windows/sessions for development
#######################################################################

workRoot="$HOME/Development/work"

session="dotfiles"
if ! (tmux has-session -t $session 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s $session -d -c "$HOME/Development/dotfiles"

  echo "  Start editor via \"vim\""
  tmux send-key -t $session:1 'vim' C-m
fi

session="idss"
if ! (tmux has-session -t $session 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s $session -d -c "$workRoot/idss-shared-resources"

  echo "  Start services via \"docker-compose up\""
  tmux send-key -t $session:1 'docker-compose up' C-m
fi

session="dam"
if ! (tmux has-session -t $session 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s $session -d -c "$workRoot/epos.dam"
fi

session="crm-bridge"
if ! (tmux has-session -t $session 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s $session -d -c "$workRoot/epos.crm-bridge"
fi

session="student-enrolement"
if ! (tmux has-session -t $session 2>/dev/null); then
  echo "Create \"$session\" session"
  tmux new-session -s $session -d -c "$workRoot/epos.student-enrolment"
fi
