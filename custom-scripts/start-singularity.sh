#!/usr/bin/env bash

session="Singularity"
pathApi="/home/eckon/Development/singularity2-api"
pathFrontend="/home/eckon/Development/singularity2-frontend"

# only run tmux script when the session is not already created
if ! (tmux has-session -t $session 2>/dev/null); then
  # handle backend api project view
  tmux new-session -s $session -d -c $pathApi
  tmux rename-window -t $session:1 'Api'
  tmux send-key -t $session:1 'vv' C-m
  tmux split-window -t $session:1 -p 20 -v -c $pathApi
  tmux send-key -t $session:1 'npm run start:dev' C-m
  tmux split-window -t $session:1 -h -c $pathApi
  # set focus of this window (1) to the editor editor
  tmux select-pane -t $session:1 -U

  # handle frontend project view
  tmux new-window -t $session:2 -n 'Frontend' -c $pathFrontend
  tmux send-key -t $session:2 'vv' C-m
  tmux split-window -t $session:2 -p 20 -v -c $pathFrontend
  tmux send-key -t $session:2 'npm start' C-m
  tmux split-window -t $session:2 -h -c $pathFrontend
  # set focus of this window (2) to the editor pane
  tmux select-pane -t $session:2 -U

  # handle backend structure view
  tmux new-window -t $session:3 -n 'Api-Docker' -c $pathApi
  tmux send-key -t $session:3 'docker-compose up' C-m

  # set focus of the session to the first window
  tmux select-window -t $session:1
fi

tmux attach-session -t $session
