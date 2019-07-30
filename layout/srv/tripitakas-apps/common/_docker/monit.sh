#!/bin/bash

[[ -z $VERB ]] && VERB=1
[[ -z $SLEEP_TIME ]] && SLEEP_TIME=60

# expect one argument "branch_name"
function checkout_and_copy {
  _repo=$1
  _br=$2

  _cp_path="../../copies/${_repo}.${_br}"

  git checkout $_br
  [[ ! -d $_cp_path ]] && mkdir -p $_cp_path && rsync -az --exclude .git . $_cp_path

  _diff=`git diff --name-only $_br origin/$_br`

  if [[ -n $_diff ]]; then
    echo "   updating branch $_br"
    git merge origin/$_br
    rsync -az --exclude .git . $_cp_path
  else
    [[ $VERB = 1 ]] && echo "   nochange of branch $_br, skip"
  fi
}

# expect one argument "branch_name"
function fetch_and_check {
  _repo=$1

  cd $_repo

  git fetch --all

  for _br in `ls .git/refs/remotes/origin/`; do
    [[ $_br = 'HEAD' ]] && continue
    checkout_and_copy $_repo $_br
  done

  cd ..
}

# working dir
[[ ! -d /work/git_repos ]] && mkdir -p /work/git_repos
cd /work/git_repos

# loop like a daemon
while true; do
  for _repo in * ; do
    if [[ -d $_repo/.git ]]; then
      [[ $VERB = 1 ]] && echo "checking git status for $_repo ..."
      fetch_and_check $_repo
    fi
  done

  sleep $SLEEP_TIME
done
