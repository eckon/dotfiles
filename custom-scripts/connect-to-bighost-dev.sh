#!/usr/bin/env bash

########################################################
# script to quickly connect to the bighost-dev container
########################################################

# get information about bighost dev from the manager in a nice format
serviceInfo=$(
  ssh manager \
    'docker service ps -f "desired-state=running" --format "{{.Node}} {{.Name}}.{{.ID}}" --no-trunc bighost-dev'
)

# given format: swarm-name.domain.com container-name.number.id
# first part before "." is needed (swarmX)
host=$(
  echo "$serviceInfo" | awk -F '.' '{print $1}'
)
# secound part after " " is needed (bighost-dev.1.abcdef12345)
container=$(
  echo "$serviceInfo" | awk '{print $2}'
)

echo "[!] Found \"$host\" with \"$container\""
echo "[!] Trying to execute into it"

ssh -t "$host" "docker exec -w '/opt/myWebsites/singularity/www/cli/' -it $container bash"
