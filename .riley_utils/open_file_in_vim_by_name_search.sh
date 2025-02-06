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

# If the user provides a second param then we want to use
# that as the subdirectory that we are searching in.
DIR='.'
if [ ! -z "$2" ];
then
  DIR="${2}"
fi

# If there's a slash at the end of the search directory, remove it.
# Find doesn't need it and it makes the file paths ugly.
if [[ "$DIR" == */ ]];
then
  DIR="${DIR%?}"
fi

# NOTE: if you ever want to exclude more directory names than just 'node_modules' then
# add "-o -name dir_name_to_be_excluded" after 'node_modules' in our below command.
FILES=$(find -E $DIR -type d \( -name node_modules \) -prune -o -type f -iregex ".*/${1}[^/]*" -print )

# Figure out how many files there are.
NUM_OF_FILES=$(echo "$FILES" | wc -l)

# TODO show an error messge and don't open vim if there are no files.
# TODO adjust this script to allow you to provide multiple inputs and it will open each of the inputs you provide if it finds files for them.
# TODO adjust this script so if you pass in something with a "/" then you will check the entire filepath rather than just the specific file name so you can still use this tool to open index.tsx files (for instance).

# If there's only 1 file then just open it.
if [ $NUM_OF_FILES = 1 ];
then
  vim -p $(echo "$FILES")
else
  # If there's more than one file then have the user choose which file they want to open.

  # Set up our read prompt style variables.
  READ_PROMPT_COLOR=$'\e[0;33m'
  READ_PROMPT_NO_COLOR=$'\e[0m'
  READ_PROMPT_UNDERLINE="$(tput smul)"
  READ_PROMPT_NO_UNDERLINE="$(tput rmul)"

  # Tell the user that we have more than 1 file.
  echo;
  echo '\033[0;33mMultiple matching files found.\033[0m';
  echo;

  # Loop until the user inputs a valid number for a file.
  CONTINUE='true'
  while [ $CONTINUE = 'true' ];
  do
    # Show the user the files.
    echo "$FILES" | sed "s,\.\/, ,g" | nl -s : -n rn -w 2 | sed "s,^,$(printf "\033")[0;33m,g" | sed "s,: ,:$(printf '\033')[0m ,g";
    echo;

    # Get the user's selection.
    read -p "${READ_PROMPT_COLOR}${READ_PROMPT_UNDERLINE}Please type the number of the file that you would like to open:${READ_PROMPT_NO_UNDERLINE}${READ_PROMPT_NO_COLOR} ";
    echo;

    # Make sure that the user's input was a number and also corresponded to a file that we can open.
    num_regex='^[0-9]+$'
    if ! [[ $REPLY =~ $num_regex ]];
    then
      echo_error 'Input was not a number.'
    elif [[ $REPLY -gt $NUM_OF_FILES ]] || [[ $REPLY = 0 ]];
    then
      echo_error 'No file with that number.'
    else
      # If the user input was good then open the file.
      CONTINUE='false'
      vim $(echo "$FILES" | sed -n "${REPLY}p")
    fi
  done
fi
