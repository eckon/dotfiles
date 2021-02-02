#!/usr/bin/env bash

#####################################################################
# script to quickly clone gitlab repositories inside of a fzf session
#
# usage:
#   - without arguments: shows all available repositories
#   - with arguments: pre filters the search with the given value
#
# dependencies:
#   - fzf, jq, curl, bash,
#   - variables.cfg
#     - GITLAB_PROJECTS_URL is the url to the gitlab projects api
#     - GITLAB_ACCESS_TOKEN is the access key from gitlab
#####################################################################

# get url (GITLAB_PROJECTS_URL) and access token (GITLAB_ACCESS_TOKEN) from a config file
variablePath="${BASH_SOURCE%/*}/variables.cfg"
if test -f "$variablePath"; then
  source "$variablePath"
  header="PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN"
  url=$GITLAB_PROJECTS_URL
else
  echo "Config file '$variablePath' could not be found."
  echo "It needs 'GITLAB_ACCESS_TOKEN' and 'GITLAB_PROJECTS_URL'."
  echo "GITLAB_ACCESS_TOKEN needs to be created by gitlab and requires api read permissions."
  echo "GITLAB_PROJECTS_URL needs to point to the projects api (example: 'gitlab.com/api/v4/projects')."
  exit 1
fi

# if we have a parameter, just get first 100 of search responses
if [[ $# -gt 0 ]]; then
  gitlabUrl=$(
    curl --silent --header "$header" \
      "$url?per_page=100&page=1&search=$1" \
      | jq ".[].ssh_url_to_repo" \
      | tr -d '"' \
      | fzf -q "$1"
  )
fi

# without parameter request all pages
if [[ $# == 0 ]]; then
  currentPage=1
  perPage=20

  gitlabUrl=$(
    {
      # get page count out of header response data
      pageCount=$(
        curl -I -X GET --silent --header "$header" \
          "$url" \
          | awk '/x-total-pages/ { print $2 }' \
          | tr -d "\r"
      )

      # now get all pages from the api
      while (( currentPage <= pageCount )); do
        curl --silent --header "$header" \
          "$url?per_page=$perPage&page=$currentPage&order_by=last_activity_at" \
          | jq ".[].ssh_url_to_repo" \
          | tr -d '"' &
        currentPage=$(( currentPage + 1 ))
      done
    } | fzf
  )
fi

if [[ $gitlabUrl != "" ]]; then
  git clone "$gitlabUrl"
fi
