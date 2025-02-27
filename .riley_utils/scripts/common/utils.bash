#!/bin/bash

# This file contains common utility functions for the rest of the scripts.

BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
BOLD_YELLOW='\033[1;33m'
BOLD_TEAL='\033[1;36m'
NO_COLOR='\033[0m'
UNDERLINE="$(tput smul)"
NO_UNDERLINE="$(tput rmul)"

echo_command()
{
  echo -e "${BOLD_GREEN}$1${NO_COLOR}"
}

echo_error()
{
  echo -e "${BOLD_RED}$1${NO_COLOR}"
}

echo_warning()
{
  echo -e "${BOLD_YELLOW}$1${NO_COLOR}"
}

# USAGE:
# if prompt_user_yes_no "a question/prompt for the user";
# then
#   echo "they said yes"
# else
#   echo "they said no"
# fi
prompt_user_yes_no()
{
  while [ 1 ];
  do
    # Have to echo the output into the read command in order to get the read command to have coloring the way I want it to.
    read -p "$(echo -e "${BOLD_YELLOW}${UNDERLINE}$1 [y/n]:${NO_UNDERLINE}${NO_COLOR} ")" REPLY;
    echo;

    # Make sure that the user's input was a number and also corresponded to a file that we can open.
    yes_no_regex='^[ynYN]$'
    yes_regex='^[yY]$'
    no_regex='^[nN]$'
    if echo "${REPLY}" | egrep -q "${yes_no_regex}";
    then
      if echo "${REPLY}" | egrep -q "${yes_regex}";
      then
        return 0
      elif echo "${REPLY}" | egrep -q "${no_regex}";
      then
        return 1
      else
        # Theoretically this condition should never get hit if our regexes are working properly.
        echo_error "Something went wrong with the yes/no prompt."
        exit 1
      fi
    else
      # If the user input was bad then let them know then loop again.
      echo_error "Bad input! Please enter either \"y\" or \"n\"."
    fi
  done
}

# USAGE:
# prompt_user_input "this is a prompt"
# $REPLY <-- will contain whatever the user typed in.
prompt_user_input()
{
  # Have to echo the output into the read command in order to get the read command to have coloring the way I want it to.
  read -p "$(echo -e "${BOLD_YELLOW}${UNDERLINE}$1:${NO_UNDERLINE}${NO_COLOR} ")" REPLY;
  echo;
}

print_logo() {
  echo -e "
  ╔══════════════════════════════════════════════════════════════════╗
  ║ ${BOLD_GREEN}☻${NO_COLOR} ${BOLD_YELLOW}☻${NO_COLOR} ${BOLD_RED}☻${NO_COLOR}                     Riley Utils                            ║
  ╠══════════════════════════════════════════════════════════════════╣
  ║${BOLD_TEAL}                    :@                                            ${NO_COLOR}║
  ║${BOLD_TEAL}              +.@@@@@@@:.@%:   =      =@@@: .=                    ${NO_COLOR}║
  ║${BOLD_TEAL}            *@@@@@@@@@@@@@@@@@%%%%#@@@@@@@@@@@@@                  ${NO_COLOR}║
  ║${BOLD_TEAL}            @%%=@@@@@@@ @::@@@@@@@@@@%%* :::.:%%%@                ${NO_COLOR}║
  ║${BOLD_TEAL}           .@@@@@@@@@@@@@.-@@@@@@%%:------- :::::*%@@*            ${NO_COLOR}║
  ║${BOLD_TEAL}           @@@@@@@@@@@@@@@@@@@@@@%-----------::::::%%@@@@@        ${NO_COLOR}║
  ║${BOLD_TEAL}            @+@@=..@@@@@@@@@@@@@@@%-----------::::::%%            ${NO_COLOR}║
  ║${BOLD_TEAL}           @@@@@...@@@@@@@@@@ @@@@%%-------***++:::.%             ${NO_COLOR}║
  ║${BOLD_TEAL}          @@@@@@...*@@@@@@@@@@@@#@@%%-----***+++++-%              ${NO_COLOR}║
  ║${BOLD_TEAL}        *    @@@. ==@@@@@@@ @@@@@ @@@@%%.**:+++++*%               ${NO_COLOR}║
  ║${BOLD_TEAL}            @.@@*** @@@@@@@-@@@@@@@@@@@@@@@+::#%%                 ${NO_COLOR}║
  ║${BOLD_TEAL}              -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  .@@@@              ${NO_COLOR}║
  ║${BOLD_TEAL}                @@@@@@@@@@@@@@@@@@@@@@@@@@+++@#%%%%               ${NO_COLOR}║
  ║${BOLD_TEAL}                =@@@@@@@@@@@@@@@@@@@@@@@@@@++@%-%+                ${NO_COLOR}║
  ║${BOLD_TEAL}                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%                  ${NO_COLOR}║
  ║${BOLD_TEAL}               =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%@=              ${NO_COLOR}║
  ║${BOLD_TEAL}               .@@@@@@@@@@@@@@@@@@@@++@@@@@@%%%%%*                ${NO_COLOR}║
  ║${BOLD_TEAL}               .@@ @@@@@@@@@@@@@@@@@+++@@@%%%%:#%                 ${NO_COLOR}║
  ║${BOLD_TEAL}                @@%*%%%%%%%%@@@@@@@@@@@%%%%%%%::%                 ${NO_COLOR}║
  ║${BOLD_TEAL}                @@%%+%%%%%% @@@@@@:@@%%%%%%%%%:%.                 ${NO_COLOR}║
  ║${BOLD_TEAL}                @@%%%%.%%%%%%@@@@@++%%%%%%%%%%%.                  ${NO_COLOR}║
  ║${BOLD_TEAL}                 @%%%%%+ %%%#%@@@@@%%%%%%:%%%%%.                  ${NO_COLOR}║
  ║${BOLD_TEAL}                 @%%%%=     %%%%%%%% %%%%%=%%%%%                  ${NO_COLOR}║
  ║${BOLD_TEAL}                @@@.@       @ %%%%%%  -@@ %%=%%%                  ${NO_COLOR}║
  ║${BOLD_TEAL}                             ..- +%@       @@                     ${NO_COLOR}║
  ║${BOLD_TEAL}                               *@@                                ${NO_COLOR}║
  ╚══════════════════════════════════════════════════════════════════╝
"
}

try_install() {
  if test "$( dpkg --get-selections | grep -v deinstall | grep -w $1 | wc -l )" -gt "0"
  then
    echo_warning "$1 already installed!"
  else
    echo_command "Installing $1"
    sudo apt-get install $1
    if [ $? -ne 0 ]; then
      echo_error "👆 Problem installing dependencies: Check the output from apt-get 👆"
      exit 1
    fi
  fi
}

parallel_commands() {
  for cmd in "$@"; do {
    echo "Process \"$cmd\" started";
    $cmd & pid=$!
    PID_LIST+=" $pid";
  } done

  trap "kill $PID_LIST" SIGINT

  echo "Parallel processes have started";

  wait $PID_LIST

  echo
  echo "All processes have completed";
}

print_help()
{
  input="$RV_UTILS_PATH/documentation/${1}.txt"
  while IFS= read -r line
  do
    # If the line of the .txt file starts with #, make it teal
    # If the line of the .txt file starts with ##, make it green
    if echo "${line}" | egrep -q "^\##.*$";
    then
      line_text=$(echo "$line" | sed -r 's/^## (.*)$/\1/')
      echo -e "${BOLD_GREEN}$line_text"
    elif echo "${line}" | egrep -q "^\#.*$";
    then
      line_text=$(echo "$line" | sed -r 's/^# (.*)$/\1/')
      echo -e "${BOLD_TEAL}$line_text"
    else
      echo -e "${NO_COLOR}$line"
    fi
  done < "$input"
}

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

# Pulls the values of the environment variables and puts them in accessible bash variables.
#
# LIST OF AVAILABLE ENVIRONMENT VARIABLES:
# EMAIL_ADDRESS
function fetch_env_vars()
{
  if [ -f $RV_UTILS_PATH/env.json ]; then
      EMAIL_ADDRESS=$(cat $RV_UTILS_PATH/env.json | jq -r '."EMAIL_ADDRESS"') # for example, riley@freewill.com
  else
    echo_error "env.json file was not found in directory $RV_UTILS_PATH. Try running ${BOLD_TEAL}rv config${NO_COLOR}"
    exit 1
  fi
}
