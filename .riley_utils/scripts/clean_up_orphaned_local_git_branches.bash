#!/bin/bash

################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/common/utils.sh
. $(dirname "$0")/common/env_vars.sh
fetch_env_vars

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

# Grab the git stash list count.
ORIGINAL_GIT_STASH_COUNT=$(git stash list | wc -l)

# Stash the current changes
echo_command "git stash"
git stash

# Grab the git stash list count.
NEW_GIT_STASH_COUNT=$(git stash list | wc -l)

# Switch over to the base branch because this script shouldn't ever end up deleting the base branch.
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

# Grab all the remote branches that fit the naming scheme used for my development branches "riley/BRANCH-NAME".
echo_command "Finding orphaned local branches..."
REMOTE_BRANCHES=$(git ls-remote --quiet | egrep -o "refs\/heads\/$GITHUB_BRANCH_IDENTIFIER\/.+" | egrep -o "$GITHUB_BRANCH_IDENTIFIER\/.+")

# Transfer our remote branches into an array.
REMOTE_BRANCHES_ARRAY=($(echo $REMOTE_BRANCHES | tr " " "\n"))

# Grab all the local branches that fit the naming scheme used for my development branches "$GITHUB_BRANCH_IDENTIFIER/BRANCH-NAME".
LOCAL_BRANCHES=$(git branch | egrep -o "$GITHUB_BRANCH_IDENTIFIER\/.+")

# Transfer our local branches into an array.
LOCAL_BRANCHES_ARRAY=($(echo $LOCAL_BRANCHES | tr " " "\n"))


LOCAL_BRANCHES_TO_DELETE=()
#LOCAL_BRANCHES_TO_DELETE+=("TESTING")

for local_branch in "${LOCAL_BRANCHES_ARRAY[@]}"
do
  FOUND_REMOTE_BRANCH="false"

  for remote_branch in "${REMOTE_BRANCHES_ARRAY[@]}"
  do
    if [[ "$remote_branch" == "$local_branch" ]];
    then
      FOUND_REMOTE_BRANCH="true"
    fi
  done

  if [[ $FOUND_REMOTE_BRANCH == "false" ]];
  then
    LOCAL_BRANCHES_TO_DELETE+=($local_branch)
  fi
done

if [[ ${#LOCAL_BRANCHES_TO_DELETE[@]} -gt 0 ]];
then

  # Set up our read prompt style variables.
  READ_PROMPT_COLOR=$'\e[0;33m'
  READ_PROMPT_NO_COLOR=$'\e[0m'
  READ_PROMPT_UNDERLINE="$(tput smul)"
  READ_PROMPT_NO_UNDERLINE="$(tput rmul)"

  CONTINUE='true'
  while [ $CONTINUE = 'true' ];
  do
    # Build a string of all the branches to be deleted with newlines so we can display them below.
    LOCAL_BRANCHES_TO_DELETE_STRING="${LOCAL_BRANCHES_TO_DELETE[0]}"
    for (( i=0 ; i<${#LOCAL_BRANCHES_TO_DELETE[@]} ; i++ ));
    do
      if [ $i -gt 0 ];
      then
        LOCAL_BRANCHES_TO_DELETE_STRING="${LOCAL_BRANCHES_TO_DELETE_STRING}\n${LOCAL_BRANCHES_TO_DELETE[$i]}"
      fi
    done

    # Show the user the branches to be deleted.
    echo;
    echo "$(printf "\033")[0;33mLocal orphaned branches to be deleted:$(printf '\033')[0m"
    echo "$LOCAL_BRANCHES_TO_DELETE_STRING" | nl -s : -n rn -w 2 | sed "s,^,$(printf "\033")[0;33m,g" | sed "s,:,:$(printf '\033')[0m ,g";
    echo;

    # Get the user's selection.
    read -p "${READ_PROMPT_COLOR}${READ_PROMPT_UNDERLINE}Please confirm that these are the branches you wish to delete [y/n]:${READ_PROMPT_NO_UNDERLINE}${READ_PROMPT_NO_COLOR} ";
    echo;

    # Make sure that the user's input was a number and also corresponded to a file that we can open.
    yes_no_regex='/^[ynYN]$/'
    yes_regex='^[yY]$'
    no_regex='^[nN]$'
    if ! [[ $REPLY =~ $yes_no_regex ]];
    then
      if [[ $REPLY =~ $yes_regex ]];
      then
        # If the user said yes then proceed to delete the branches then end the loop.
        for local_branch_to_delete in "${LOCAL_BRANCHES_TO_DELETE[@]}"
        do
          echo_command "git branch -D ${local_branch_to_delete}"
          git branch -D $local_branch_to_delete
        done
        echo;
        CONTINUE='false'
      elif [[ $REPLY =~ $no_regex ]];
      then
        # If the user said no then print a message then end the loop.
        echo_error "No branches deleted..."
        CONTINUE='false'
      else
        echo_error "Something went wrong."
        exit 1
      fi
    else
      # If the user input was bad then let them know then loop again.
      echo_error "Bad input! Please enter either \"y\" or \"n\"."
    fi
  done
else
  echo "$(printf "\033")[0;33mNo orphaned branches found!$(printf '\033')[0m"
fi

# Find out if the current branch still exists or not.
CURRENT_BRANCH_STILL_EXISTS=$(git branch | egrep -o "^\s*${CURRENT_BRANCH}\s*$" | wc -l)

# If the current brach still exists then switch back to it and drop our git stash there.
if [[ $CURRENT_BRANCH_STILL_EXISTS -gt 0 ]];
then
  # Switch back to the current branch.
  echo_command "git checkout ${CURRENT_BRANCH}"
  git checkout $CURRENT_BRANCH

  # Don't pop off the stash unless we actually stashed something earlier in the script.
  if [ $ORIGINAL_GIT_STASH_COUNT -lt $NEW_GIT_STASH_COUNT ];
  then
    # Pop the stash so we have our current changes back.
    echo_command "git stash pop"
    git stash pop
  fi
fi

# Display the git status.
echo_command "git status"
git status
