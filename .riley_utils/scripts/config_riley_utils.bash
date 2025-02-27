#!/bin/bash

################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/common/utils.sh

# Get the full absolute path to this script's directory so we can find the location for our env.json file.
THIS_SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Build the env.json file path.
ENV_JSON_FILENAME="${THIS_SCRIPT_DIR}/../env.json"

# Prompt user for inputs for environment variables.
CONTINUE='true'
while [ $CONTINUE = 'true' ];
do
  prompt_user_input "What is your github account's email address"
  EMAIL_ADDRESS="${REPLY}"
  EMAIL_ADDRESS_REGEX='^[a-zA-Z0-9\.]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+$'

  # Confirm that the provided input is a valid email address before continuing.
  if echo "${EMAIL_ADDRESS}" | egrep -q "${EMAIL_ADDRESS_REGEX}";
  then
    CONTINUE='false'
  else
    echo_error "Was not a valid email address! Trying again..."
  fi
done

# Show the user they're inputs and have them confirm that they're correct before moving on.
echo_warning "So the values you've provided are: "
echo_command "Email Address: ${NO_COLOR}${EMAIL_ADDRESS}"
if ! prompt_user_yes_no "Please confirm that these values are correct";
then
  echo_error "Please run the script again and provide the correct values."
  exit 1
fi

# Create the env.json file.
echo_command "Creating environment variables file"
if [ -f env.json ];
then
  echo_warning "Skipping as ${ENV_JSON_FILENAME} already exists"
else
  touch $ENV_JSON_FILENAME
  echo "{}" > $ENV_JSON_FILENAME
fi
echo

###############
# SYSTEM variables we want to save
###############

echo_command "Saving environment variables to file"
echo

# Use jq to edit the json and save it back to the env.json file.
JQ_SET_EMAIL_ADDRESS_ARG=".\"EMAIL_ADDRESS\" = \"${EMAIL_ADDRESS}\""
echo $(cat $ENV_JSON_FILENAME | jq "${JQ_SET_EMAIL_ADDRESS_ARG}") > $ENV_JSON_FILENAME
