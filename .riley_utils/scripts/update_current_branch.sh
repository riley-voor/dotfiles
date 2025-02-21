#!/bin/sh


################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/common/utils.sh

####################
### SCRIPT START ###
####################

# The base branch for all our development branches in the freewill repo is "develop".
BASE_BRANCH="develop"

# Grab the current branch name.
CURRENT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

# Put a sleep for 1 second here because otherwise we'll try to run the next command at the
# same time as we run the git branch command for CURRENT_BRANCH and that'll cause problems.
sleep 1

# If we're already on develop then don't do anything.
if [[ "$CURRENT_BRANCH" == "$BASE_BRANCH" ]];
then
  echo_error "Already on base branch"
  exit 1
fi

# Switch over to the base branch.
echo_command "git checkout $BASE_BRANCH"
git checkout $BASE_BRANCH

# Make sure the base branch is up to date.
echo_command "git pull"
git pull

# Make sure there are no conflicts before we proceed.
CONFLICTS=$(git ls-files -u | wc -l)
if [ $CONFLICTS -gt 0 ];
then
  echo_error "There is a merge conflict in ${BASE_BRANCH}. Aborting"
  exit 1
fi

# Switch back to the current branch.
echo_command "git checkout ${CURRENT_BRANCH}"
git checkout $CURRENT_BRANCH

# Grab the git stash list count.
ORIGINAL_GIT_STASH_COUNT=$(git stash list | wc -l)

# Stash the current changes
echo_command "git stash"
git stash

# Grab the git stash list count.
NEW_GIT_STASH_COUNT=$(git stash list | wc -l)

# Merge the base branch into the current branch.
echo_command "git merge --no-edit ${BASE_BRANCH}"
git merge --no-edit $BASE_BRANCH

# Make sure there are no conflicts before we proceed.
CONFLICTS=$(git ls-files -u | wc -l)
if [ $CONFLICTS -gt 0 ];
then
  echo_error "There is a merge conflict in ${CURRENT_BRANCH}. Aborting"
  exit 1
fi

# Don't pop off the stash unless we actually stashed something earlier in the script.
if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
then
  # Pop the stash so we have our current changes back.
  echo_command "git stash pop"
  git stash pop
fi
