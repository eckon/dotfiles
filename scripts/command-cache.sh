#!/usr/bin/env bash

# script to cache the output of the first command in a pipeline
# this can be used if we call for example an api or something that takes time
# and want to grep/awk/etc something out of it and are too lazy to store it in a file beforehand
#
# just prepend the pipeline with this command and it will speed up the process
# from:    $ curl "long task" | grep ".*" | awk ...
# to:      $ command-cache curl "..." | grep "..." | ...
# example: $ curl -L "https://deelay.me/500/https://jsonplaceholder.typicode.com/todos/1"

ttl="30 minutes"
cacheFolder=~/.cache/command-cache
currentTime=$(date +"%s")

# if run first time, create cache folder
if ! test -d $cacheFolder; then
  mkdir -p $cacheFolder
fi

# iterate cache folder and delete files that are too old
# this will allow us to ignore checking ttl later on (and remove trash files)
find "$cacheFolder" -type f | while IFS= read -r cacheFile; do
  fileLastChanged=$(stat --format "%y" "$cacheFile")
  ttlResult=$(date -d "$fileLastChanged +$ttl" +"%s")

  # if ttl is reached, delete the file
  if [[ "$currentTime" > "$ttlResult" ]]; then
    rm "$cacheFile"
  fi
done

# generate a has for better file names
# md5sum returns the file as secound argument, only return the hash
commandHash=$(echo "$@" | md5sum | cut -d ' ' -f 1)
cacheFile="$cacheFolder/$commandHash"

# if cacheFile still exists, then ttl is not reached and can return content
if test -f "$cacheFile"; then
  cat "$cacheFile"
  exit 0
fi

# otherwise continue and build the cache
# either ttl was reached or no file, eval command and save it to file
eval "$@" | tee "$cacheFile"
