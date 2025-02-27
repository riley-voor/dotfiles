#!/bin/bash


################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/common/utils.bash
. $(dirname "$0")/common/env_vars.bash
fetch_env_vars

####################
### SCRIPT START ###
####################

# Move to the main freewill project repo.
echo_command "cd $API_V2_DIRECTORY"
cd $API_V2_DIRECTORY

# Grab the current branch name.
CURRENT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

# Put a sleep for 1 second here because otherwise we'll try to checkout develop at the
# same time as we run the git branch command for CURRENT_BRANCH and that'll cause problems.
sleep 1

# Grab the git stash list count.
ORIGINAL_GIT_STASH_COUNT=$(git stash list | wc -l)

# Stash the current changes
echo_command "git stash"
git stash

# Grab the git stash list count.
NEW_GIT_STASH_COUNT=$(git stash list | wc -l)

# Checkout develop and pull to make sure it's up to date.
echo_command "git checkout develop && git pull"
git checkout develop && git pull

# Make sure there are no conflicts before we proceed.
CONFLICTS=$(git ls-files -u | wc -l)
if [ $CONFLICTS -gt 0 ];
then
  if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
  then
    echo_error "There is a merge conflict in develop. Aborting. You have local changes stashed!"
  else
    echo_error "There is a merge conflict in develop. Aborting"
  fi
  exit 1
fi

# Run npm install from the root of the repo.
echo_command "npm install --silent"
npm install --silent

# Run npm install from src/ cuz it will run npm install for all the subprojects.
echo_command "cd src/ && npm install --silent && cd ../"
cd src/ && npm install --silent && cd ../

# Make sure there are no changes from npm before we proceed.
NPM_CHANGES=$(git ls-files -m | wc -l)
if [ $NPM_CHANGES -gt 0 ];
then
  if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
  then
    echo_error "There is an npm file change in develop. Aborting. You have local changes stashed!"
  else
    echo_error "There is an npm file change in develop. Aborting"
  fi
  exit 1
fi

# If we aren't on develop then we want to merge develop into our current branch.
if [ $CURRENT_BRANCH != "develop" ]
then
  # Move to the branch we originally were on.
  echo_command "git checkout ${CURRENT_BRANCH}"
  git checkout $CURRENT_BRANCH

  # # Grab the git stash list count.
  # NEW_GIT_STASH_COUNT=$(git stash list | wc -l)

  # Merge develop into it.
  echo_command "git merge develop --no-edit"
  git merge develop --no-edit

  # Make sure there are no conflicts before we proceed.
  CONFLICTS=$(git ls-files -u | wc -l)
  if [ $CONFLICTS -gt 0 ];
  then
    if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
    then
      echo_error "There is a merge conflict in ${CURRENT_BRANCH}. Aborting. You have local changes stashed!"
    else
      echo_error "There is a merge conflict in ${CURRENT_BRANCH}. Aborting"
    fi
    exit 1
  fi
fi

# Don't pop off the stash unless we actually stashed something earlier in the script.
if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
then
  # Put the current changes back now that we've merged.
  echo_command "git stash pop --quiet"
  git stash pop --quiet
fi

# Clear away the npm installation text cuz its real ugly.
echo_command "clear"
clear

# Display our git status
echo_command "git status"
git status
