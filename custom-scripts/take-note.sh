#!/usr/bin/env bash

path="$HOME/Documents/notes"
if [ ! -f $path ]; then
  mkdir -p $path
fi

file="$path/note-$(date +%Y-%m-%d).md"
if [ ! -f $file ]; then
  echo "# Notes $(date +%Y-%m-%d)" > $file
fi

nvim $file \
  -c "startinsert" \
  -c "CocDisable" \
  -c "norm G2o" \
  -c "norm Do## $(date +%H:%M)" \
  -c "norm G2o" \
  -c "norm zz"
