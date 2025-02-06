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

echo_command "cd src/app/"
cd src/app/

echo_command "npm run db baseline"
npm run db baseline

if (( $? != 0 ))
then
  echo_error "Error detected! Stopping..."
  exit 1
fi

echo_command "npm run db-migrate"
npm run db-migrate

if (( $? != 0 ))
then
  echo_error "Error detected! Stopping..."
  exit 1
fi

echo_command "cd ../../"
cd ../../

# if -c (for "connect") is provided then we end the script by connecting to the local db.
if [[ $* == *-c* ]]
then
  echo_command "clear"
  clear

  # TODO eventually it would be nice to be able to actually use the bash alias and keep the full command only in a single location
  echo_command "pgcli-fw-local"
  pgcli -U postgres -h 127.0.0.1 -d freewill_dev
fi

