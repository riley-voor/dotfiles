#!/bin/sh

# This file contains common utility functions for the rest of the scripts.

BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
BOLD_YELLOW='\033[1;33m'
BOLD_TEAL='\033[1;36m'
NO_COLOR='\033[0m'

READ_PROMPT_BOLD_YELLOW=$'\e[1;33m'
READ_PROMPT_NO_COLOR=$'\e[0m'
READ_PROMPT_UNDERLINE="$(tput smul)"
READ_PROMPT_NO_UNDERLINE="$(tput rmul)"

function echo_command()
{
  echo "${BOLD_GREEN}$1${NO_COLOR}"
}

function echo_error()
{
  echo "${BOLD_RED}$1${NO_COLOR}"
}

function echo_warning()
{
  echo "${BOLD_YELLOW}$1${NO_COLOR}"
}

# USAGE:
# if prompt_user_yes_no "a question/prompt for the user";
# then
#   echo "they said yes"
# else
#   echo "they said no"
# fi
function prompt_user_yes_no()
{
  while [ 1 ];
  do
    read -p "${READ_PROMPT_BOLD_YELLOW}${READ_PROMPT_UNDERLINE}$1 [y/n]:${READ_PROMPT_NO_UNDERLINE}${READ_PROMPT_NO_COLOR} ";
    echo;

    # Make sure that the user's input was a number and also corresponded to a file that we can open.
    yes_no_regex='^[ynYN]$'
    yes_regex='^[yY]$'
    no_regex='^[nN]$'
    if [[ $REPLY =~ $yes_no_regex ]];
    then
      if [[ $REPLY =~ $yes_regex ]];
      then
        return 0
      elif [[ $REPLY =~ $no_regex ]];
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
function prompt_user_input()
{
  read -p "${READ_PROMPT_BOLD_YELLOW}${READ_PROMPT_UNDERLINE}$1:${READ_PROMPT_NO_UNDERLINE}${READ_PROMPT_NO_COLOR} ";
  echo;
}

# TODO this might still need tweakinng but it looks pretty good for now!
function print_logo() {
  echo "


  # TODO here are useful characters: ║ █ ◢ ▀
  ┌───────────────────────────────────────────────────────────────────────────────────────────┐
  │ ${BOLD_GREEN}☻${NO_COLOR} ${BOLD_YELLOW}☻${NO_COLOR} ${BOLD_RED}☻${NO_COLOR} Riley Utils  │
  ╠══════════════════════════════════════════════════════════════════╣
  ║                    :@                                            ║
  ║              +.@       .@%:   =      =@@@: .=                    ║
  ║            *@@@@@@@@@@@@@@@@@%%%%#@@@@@@@@@@@@@                  ║
  ║            @%%=@@@@@@@ @::@@@@@@@@@@%%* :::.:%%%@                ║
  ║           .@@@@@@@@@@@@@.-@@@@@@%%:------- :::::*%@@*            ║
  ║           @@@@@@@@@@@@@@@@@@@@@@%-----------::::::%%@@@@@        ║
  ║            @+@@=..@@@@@@@@@@@@@@@%-----------::::::%%            ║
  ║           @@@@@...@@@@@@@@@@ @@@@%%-------***++:::.%             ║
  ║          @@@@@@...*@@@@@@@@@@@@#@@%%-----***+++++-%              ║
  ║        *    @@@. ==@@@@@@@ @@@@@ @@@@%%.**:+++++*%               ║
  ║            @.@@*** @@@@@@@-@@@@@@@@@@@@@@@+::#%%                 ║
  ║              -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  .@@@@              ║
  ║                @@@@@@@@@@@@@@@@@@@@@@@@@@+++@#%%%%               ║
  ║                =@@@@@@@@@@@@@@@@@@@@@@@@@@++@%-%+                ║
  ║                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%                  ║
  ║               =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%@=              ║
  ║               .@@@@@@@@@@@@@@@@@@@@++@@@@@@%%%%%*                ║
  ║               .@@ @@@@@@@@@@@@@@@@@+++@@@%%%%:#%                 ║
  ║                @@%*%%%%%%%%@@@@@@@@@@@%%%%%%%::%                 ║
  ║                @@%%+%%%%%% @@@@@@:@@%%%%%%%%%:%.                 ║
  ║                @@%%%%.%%%%%%@@@@@++%%%%%%%%%%%.                  ║
  ║                 @%%%%%+ %%%#%@@@@@%%%%%%:%%%%%.                  ║
  ║                 @%%%%=     %%%%%%%% %%%%%=%%%%%                  ║
  ║                @@@.@       @ %%%%%%  -@@ %%=%%%                  ║
  ║                             ..- +%@       @@                     ║
  ║                               *@@                                ║
  ║ $ rv                                                             ║
  ╚══════════════════════════════════════════════════════════════════╝
"
}

function try_install() {
  # TODO gotta test this
  if $1 --version > /dev/null;
  then
    echo_warning "$1 already installed!"
  else
    apt install $1
    if [ $? -ne 0 ]; then
      echo_error "👆 Problem installing dependencies: Check the output from apt 👆"
      exit 1
    fi
  fi
}

function parallel_commands() {
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
