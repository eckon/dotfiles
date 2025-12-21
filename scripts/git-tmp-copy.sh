#!/usr/bin/env bash

################################################################################
# script to quickly create a identical copy of the current git folder
# this allows for quick PRs without having to stash everything in the same repo
#
# needed plugins: git, rsync
################################################################################

# NOTE: possible improvement
# one possibility would be to copy everything except for ignored files,
# and these will be symlinked instead form the main one (resulting in less resources)
# then git worktrees might be a good soltuion as they only copy committed files

if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "Script needs to be called inside of git repository"
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel)
repo_name=$(basename "$repo_root")

copy_name="_DEEP_COPY_$repo_name"
copy_root="$repo_root/$copy_name/"

if test -d "$copy_root"; then
  printf "Copy already exists, skipping script\n(to copy again, remove \"%s\")" "$copy_root"
  exit 1
fi

pushd "$repo_root" > /dev/null || exit
printf "Copy from \n\"%s\" to\n\"%s\"\n" "$(pwd)" "$copy_root"

# to distinguish between enter, space, esc etc (otherwise all would be the same)
IFS=""
read -p "Continue? [Y/n]" -s -n 1 -r confirm
printf "\n\n"

if ! { [[ $confirm == [yY] ]] || [[ $confirm == "" ]]; }; then
  exit 1
fi

rsync -Rr . "$copy_name"

if git status -s | grep "$copy_name" -q; then
  printf "\"%s\" found in git status, appending .gitignore\n" "$copy_name"
  printf "\n\n# DEEP_COPY IGNORE: DO NOT COMMIT\n%s" "$copy_name" >> .gitignore
fi

popd > /dev/null || exit

echo "Created \"$copy_name\""
