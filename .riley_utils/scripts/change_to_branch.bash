#!/bin/bash

################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/common/utils.bash


#######################
### PARSE OPTIONS   ###
#######################

# TODO the options parsing here is broken since I removed getopts from the dependencies. Not sure if I should keep it or not. We'll see.
FORCE_NEW=0
FORCE_EXISTING=0
long_options=help,new,existing
short_options=hne
# Parse the arguments using the getopt command.
VALID_ARGS=$( $GETOPT_DIRECTORY -n 'fw' -o $short_options -l $long_options -- "$@" )

# Check for errors.
if [ $? -ne 0 ]; then
  exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -h | --help)
        print_help 'branch'
        shift;
        ;;
    -n | --new)
        FORCE_NEW=1
        shift
        ;;
    -e | --existing)
        FORCE_EXISTING=1
        shift
        ;;
    --) shift;
        break
        ;;
  esac
done

if [ $FORCE_NEW -eq 1 ] &&  [ $FORCE_EXISTING -eq 1 ]; then
  echo_error "You can't use --new and --existing options at the same time. Aborting."
  exit 1
fi

#######################
### PARSE THE INPUT ###
#######################

# Grab the branch name
NEW_BRANCH_NAME=$1

# Check that branch name exists
if [ -z "$NEW_BRANCH_NAME" ];
then
  echo_error "No new branch name supplied. Aborting."
  exit 1
fi

if [ "$NEW_BRANCH_NAME" == "master" ];
then
  echo_command "git checkout master"
  git checkout master
  exit 0
fi;

# If the branch name you just put in has a prefix (like "clara/" or "hotfix/" or "chore/")
# then you can just keep going. but if it doesn't, this will add your prefix to the name!
if [[ !($NEW_BRANCH_NAME =~ /) ]];
then
  NEW_BRANCH_NAME="$GITHUB_BRANCH_IDENTIFIER/$NEW_BRANCH_NAME"
fi

# Check if the branch exists -- this will return 1 if it doesn't, 0 if it does
git show-ref --verify --quiet refs/heads/$NEW_BRANCH_NAME
if [ $? -eq 0 ];
then
  if [ $FORCE_NEW -eq 0 ]; then
    git checkout $NEW_BRANCH_NAME
  else
    echo_error "Branch $NEW_BRANCH_NAME exists. Aborting."
    echo "If you wanted to switch to that branch, try running \`fw branch\` without the --new flag"
    exit 1
  fi
else
  if [ $FORCE_EXISTING -eq 0 ]; then
    new_branch $NEW_BRANCH_NAME
  else
    echo_error "Branch $NEW_BRANCH_NAME not found. Aborting."
    echo "If you wanted to create that branch, try running \`fw branch\` without the --existing flag"
    exit 1

  fi
fi
