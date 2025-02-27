#!/bin/bash

# LIST OF AVAILABLE ENVIRONMENT VARIABLES:
# EMAIL_ADDRESS
# GITHUB_USERNAME

# Pulls the values of the environment variables and puts them in accessible bash variables.
function fetch_env_vars()
{
  if [ -f $RV_UTILS_PATH/env.json ]; then
      EMAIL_ADDRESS=$(cat $RV_UTILS_PATH/env.json | jq -r '."EMAIL_ADDRESS"') # for example, riley@freewill.com
  else
    echo_error "env.json file was not found in directory $RV_UTILS_PATH. Try running ${BOLD_TEAL}rv config${NO_COLOR}"
    exit 1
  fi
}
