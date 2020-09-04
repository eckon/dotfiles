#!/usr/bin/env bash

# script to quickly clone gitlab repos
header="PRIVATE-TOKEN: <access-token>"  # your access token (needs api read access)
url="gitlab.com/api/v4/projects"        # your gitlab projects api

# if we have a parameter, just get first 100 of search responses
if [[ $# > 0 ]]; then
  gitlabUrl=$(
    curl --silent --header "$header" \
      "$url?per_page=100&page=1&search=$1" \
      | jq ".[].ssh_url_to_repo" \
      | tr -d '"' \
      | fzf -q"$1"
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
      while (( $currentPage <= $pageCount ));do
        curl --silent --header "$header" \
          "$url?per_page=$perPage&page=$currentPage&order_by=last_activity_at" \
          | jq ".[].ssh_url_to_repo" \
          | tr -d '"' &
        currentPage=$[ $currentPage+1 ]
      done
    } | fzf
  )
fi

if [[ $gitlabUrl != "" ]];then
  git clone $gitlabUrl
fi

