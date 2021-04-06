#!/usr/bin/env bash

#########################################################
# script to quickly toggle docker-compose file on and off
#########################################################

if ! data=$(docker-compose ps); then
  exit
fi
numerOfLines=$(echo "$data" | wc -l)

# first two lines are header, so if its greater or equal 2+1 then its running
if [[ $numerOfLines -le 2 ]]; then
  echo "No containers found -> Starting containers: docker-compose up"
  docker-compose up
else
  echo "Containers found -> Stopping containers: docker-compose down"
  docker-compose down
fi
