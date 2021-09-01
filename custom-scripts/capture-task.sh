#!/usr/bin/env bash

# small script to quickly add tasks to todoist
# only setup that is needed is to have the access token in the env available
# needed `TODOIST_TOKEN`
# this could be done by alias "alias TODOIST_TOKEN=123 capture-task"
# token can be found in todoist under `Settings` -> `Integrations` -> `API token`

# check if needed variables are available
if [ -z ${TODOIST_TOKEN+x} ]; then
  echo "TODOIST_TOKEN was not set, it is needed to connect with the API"
  exit 1
fi

# build template for the capture
captureFile=/tmp/todoist-capture.md
captureFileTemplate="# Quickly add task
- after and on the same line \`>\` is the title
- everything after the title is the description

---

> "
echo "$captureFileTemplate" > "$captureFile"

# let the user add their notes/todos/etc
nvim +"$titleLine" "$captureFile"

# parse the needed lines
titleLine=7
contentStartLine=8
title=$(awk -vline="$titleLine" 'NR==line' "$captureFile" | cut -c 3-)
description=$(awk -vline="$contentStartLine" 'NR>=line' "$captureFile")

# ask user for confirmation
echo "Title: $title

Description:
$description
"
read -p "Continue?" -n 1

# replace new lines with \n for the api
description=$(echo "$description" | awk '{printf "%s\\n", $0}')
# escape characers like "
description=$(echo "$description" | sed 's/"/\\"/g')

# create new task
curl "https://api.todoist.com/rest/v1/tasks" \
  -X POST \
  --data \
    "{
      \"content\": \"$title\",
      \"description\": \"$description\"
    }" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TODOIST_TOKEN"
