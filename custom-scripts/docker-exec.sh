#!/usr/bin/env bash

################################################################################
# script to quickly run the docker exec command with bash/sh on chosen container
################################################################################

# evaluate docker output once to not call it multiple times
data=$(
  docker ps --format="table {{.Names}}\t{{.Ports}}\t{{.Image}}\t{{.ID}}"
)

# check if theres at least one running docker (2 lines, first is the header)
running=$(echo "$data" | wc -l)
if [[ $running -le 1 ]]; then
  echo "No images are running, exiting script"
  exit
fi

# add the header to fzf, so we add it here (only the first line) and
# delete the header in the later docker call (everthing except the first line)
header=$(
  echo "$data" | awk 'NR == 1'
)

# get all running docker container and select one with fzf
container=$(
  {
    echo "$data" | awk 'NR > 1'
  } | fzf --reverse --header="$header"
)

# get the last field (container id) out of the selected container
id=$(
  echo "$container" | awk '{print $NF}'
)

if [[ $id == "" ]]; then
  echo "No image was selected, exiting script"
  exit
fi

# try executing given container id with bash (if error continue)
if docker exec -it "$id" bash; then
# if bash did not work try sh as tty
  echo "Bash not found, try sh"
  docker exec -it "$id" sh
fi
