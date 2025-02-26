#!/bin/sh

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
  echo "${BOLD_GREEN}$1${NO_COLOR}"
}

echo_error()
{
  echo "${BOLD_RED}$1${NO_COLOR}"
}

echo_warning()
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
prompt_user_yes_no()
{
  while [ 1 ];
  do
    # Have to echo the output into the read command in order to get the read command to have coloring the way I want it to.
    read -p "$(echo "${BOLD_YELLOW}${UNDERLINE}$1 [y/n]:${NO_UNDERLINE}${NO_COLOR} ")" REPLY;
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
  read -p "$(echo "${BOLD_YELLOW}${UNDERLINE}$1:${NO_UNDERLINE}${NO_COLOR} ")" REPLY;
  echo;
}

print_logo() {
  echo "
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
  ║ $ rv                                                             ║
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
