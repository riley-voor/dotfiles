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

# TODO move this into a common scripts utils file somewhere
# Grab the current branch name.
CURRENT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

# Grab the name of the ephemeral environment branch.
EE_BRANCH="demo/riley"

# Put a sleep for 1 second here because otherwise we'll try to checkout develop at the
# same time as we run the git branch command for CURRENT_BRANCH and that'll cause problems.
sleep 1

# If we're already on develop then don't do anything.
if [[ "$CURRENT_BRANCH" == 'develop' ]];
then
  echo_error "Already on base branch"
  exit 1
fi

# Delete the local ee branch.
echo_command "git branch -D $EE_BRANCH"
git branch -D $EE_BRANCH

# Make a new ee branch based on the current branch.
echo_command "git checkout -b $EE_BRANCH"
git checkout -b $EE_BRANCH

# Push the new ee branch to github.
# NOTE: we do a force here because we don't care what state the remote ee
# branch is in, we just want it to be in this new state now.
# NOTE: this will trigger our actual ephemeral environemnt in aws to
# start rebuilding due to github actions.
echo_command "git push --force --set-upstream origin $EE_BRANCH"
git push --force --set-upstream origin $EE_BRANCH

# Move back to our current branch.
echo_command "git checkout $CURRENT_BRANCH"
git checkout $CURRENT_BRANCH

# Show us our git status.
echo_command "git status"
git status
