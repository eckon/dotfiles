#!/usr/bin/env bash

# script to quickly run the docker exec command with bash/sh on chosen container

# get all running docker container and select one with fzf
container=$(
  {
    docker ps --format="table {{.Names}}\t{{.Ports}}\t{{.Image}}\t{{.ID}}"
  } | fzf
)

# get the last field (container id) out of the selected container
id=$(
  echo "$container" | awk '{print $NF}'
)

if [[ $id != "" ]]; then
  docker exec -it "$id" bash

  # if bash did not work try sh as tty
  if [[ $? != 0 ]]; then
    docker exec -it "$id" sh
  fi
fi
