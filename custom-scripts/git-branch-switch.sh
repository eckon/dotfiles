#!/usr/bin/env bash

###############################################
# script to quickly switch between git branches
###############################################

branches=$(git --no-pager branch)
activeBranch=$(echo "$branches" | awk '/^*/ { print }')
inactiveBranches=$(echo "$branches" | awk '!/^*/ { print $1 }')

chosenBranch=$(
  echo "$inactiveBranches" | fzf --height 10% --reverse --header="$activeBranch"
)

if [[ $chosenBranch == "" ]]; then
  echo "No branch was selected, exiting script"
  exit
fi

git checkout "$chosenBranch"
