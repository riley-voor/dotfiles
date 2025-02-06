#!/bin/sh


################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/utils.sh


####################
### SCRIPT START ###
####################

# Grab the branch name
NEW_BRANCH_NAME=$1

# Check that branch name exists
if [ -z "$NEW_BRANCH_NAME" ];
then
  echo_error "No new branch name supplied. Aborting."
  exit 1
fi

# Checkout develop and pull to make sure it's up to date.
echo_command "git checkout develop && git pull"
git checkout develop && git pull

# Make sure there are no conflicts before we proceed.
CONFLICTS=$(git ls-files -u | wc -l)
if [ $CONFLICTS -gt 0 ];
then
  echo_error "There is a merge conflict in develop. Aborting"
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
