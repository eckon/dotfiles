#!/usr/bin/env bash

###############################################################################
# script to quickly connect to a nested docker container
#
# example would be to get into an instance of a container on a remote server
# which might have changed the id and needs to be newly identified
###############################################################################


serverName="manager"
containerName="bighost-dev"
containerCurrentPath="/opt/myWebsites/singularity/www/cli/"

# get information about bighost dev from the manager in a nice format
serviceInfo=$(
  ssh $serverName \
    'docker service ps \
      -f "desired-state=running" \
      --format "{{.Node}} {{.Name}}.{{.ID}}" \
      --no-trunc ' $containerName
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

ssh -t "$host" \
  "docker exec \
    -w '$containerCurrentPath' \
    -it $container bash"
