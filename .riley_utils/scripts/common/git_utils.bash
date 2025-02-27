#!/bin/bash

function new_branch() {
  NEW_BRANCH_NAME=$1

  # Checkout develop and pull to make sure it's up to date.
  echo_command "git checkout master && git pull"
  git checkout develop && git pull

  # Make sure there are no conflicts before we proceed.
  CONFLICTS=$(git ls-files -u | wc -l)
  if [ $CONFLICTS -gt 0 ];
  then
    echo_error "There is a merge conflict in master. Aborting"
    exit 1
  fi

  # Create our new branch off of our now up-to-date develop branch.
  echo_command "git checkout -b ${NEW_BRANCH_NAME}"
  git checkout -b $NEW_BRANCH_NAME

  # Create our new branch on remote.
  echo_command "git push --set-upstream origin ${NEW_BRANCH_NAME}"
  git push --set-upstream origin $NEW_BRANCH_NAME

  # Display our git status
  echo_command "git status"
  git status
}
