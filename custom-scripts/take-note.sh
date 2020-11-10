#!/usr/bin/env bash

notesPath="$HOME/Documents/notes"
if [ ! -f "$notesPath" ]; then
  mkdir -p "$notesPath"
fi

projectsNotesPath="$notesPath/project"
if [ ! -f "$projectsNotesPath" ]; then
  mkdir -p "$projectsNotesPath"
fi

# opened as general note down for this day and time
if [ $# = 0 ]; then
  file="$notesPath/note-$(date +%Y-%m-%d).md"
  if [ ! -f "$file" ]; then
    echo "# Notes $(date +%Y-%m-%d)" > "$file"
  fi

  nvim "$file" \
    -c "startinsert" \
    -c "CocDisable" \
    -c "normal G2o" \
    -c "normal Do## $(date +%H:%M)" \
    -c "normal G2o" \
    -c "normal zz"
fi

# opened as a todo for the given parameter (project)
# example to call it for current project:
# $ x-terminal-emulator -e take-note $(basename $(pwd))
if [ $# -gt 0 ]; then
  file="$projectsNotesPath/$1.md"
  if [ ! -f "$file" ]; then
    echo -e "# Project: $1\n\n\n" > "$file"
  fi

  nvim "$file" \
    -c "CocDisable" \
    -c "normal Gzz"
fi
