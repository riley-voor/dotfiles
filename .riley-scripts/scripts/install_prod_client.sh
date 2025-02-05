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

# Grab the git stash list count.
ORIGINAL_GIT_STASH_COUNT=$(git stash list | wc -l)

# Stash the current changes
echo_command "git stash"
git stash

# Grab the git stash list count.
NEW_GIT_STASH_COUNT=$(git stash list | wc -l)

# Move to web to point it at the latest prod client.
echo_command "cd ~/Projects/freewill-api-v2/src/web"
cd ~/Projects/freewill-api-v2/src/web

# TODO gonna want to set this up so I can pass in a param that specifies which project(s) to link the new client in.

# Install the latest client.
echo_command "npm install --silent --save @freewillpbc/client@latest"
npm install --silent --save @freewillpbc/client@latest

# Move back to the root of the project.
echo_command "cd ~/Projects/freewill-api-v2"
cd ~/Projects/freewill-api-v2

# Stage the various package files to be committed.
echo_command "git add src/web/package.json"
git add src/web/package.json

echo_command "git add src/web/package-lock.json"
git add src/web/package-lock.json

# Commit our package files.
echo_command "git commit -m \"Pointed web at latest api client version\""
git commit -m "Pointed web at latest api client version"

# Don't pop off the stash unless we actually stashed something earlier in the script.
if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
then
  # Pop the stash so we have our current changes back.
  echo_command "git stash pop"
  git stash pop
fi
