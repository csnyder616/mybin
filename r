#!/bin/bash

set -e

function repoUrl() {
  repoUrl=$(git remote get-url origin)
  if [[ "$repoUrl" =~ ^git@github\.com:.*\.git$ ]]; then
    repoSubpath=$(echo $repoUrl | sed 's/.*git\@github\.com\:\(.*\)\.git/\1/') 
    echo https://github.com/$repoSubpath
    return
  fi
}

repoUrl=$(repoUrl)
xdg-open "$repoUrl"
