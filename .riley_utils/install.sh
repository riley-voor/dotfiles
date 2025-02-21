#!/bin/sh

################
### INCLUDES ###
################

# NOTE: $(dirname "$0") is how we specify the current directory even if we are executing
# this script from a different directory (which we almost certainly are lol).
. $(dirname "$0")/scripts/common/utils.sh
print_logo

#####################
### SCRIPT BEGINS ###
#####################

# Make sure we move to the scripts directory before the rest of the script runs in case we are executing the install script from outside the repo.
THIS_SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $THIS_SCRIPT_DIR

# Let the user know that they might need to provide their sudo password at some point.
echo_warning "NOTE: This script may prompt you for your sudo password!"

# Install the CLI tools that this project depends on
echo_command "Installing dependencies. NOTE: This may take a while..."
if which apt > /dev/null; then
  echo_warning "Using Advanced Package Tool (apt)"
else
  echo_error "Advanced Package Tool (apt) not found"
  exit 1
fi

# Install dependencies
try_install "pgcli" # TODO might not need this depending on what we end up doing with our tmux coding session configuration
try_install "jq"
try_install "gh"

# Check whether the user is logged into gh or not.
if gh auth status 2> /dev/null;
then
  echo_warning "already logged into Github (gh) CLI!"
else
  echo_warning "You will be prompted to log in to the Github (gh) CLI. Please select 'skip' if prompted to upload your ssh key."
  sleep 3
  gh auth login --hostname github.com --web -p ssh
fi

echo

# Call the environment variables set up.
./scripts/config_riley_utils.sh

# Set up the "rv" command that points to the main.sh script.
echo_command "Installing 'rv' command"
echo
if [ -f /usr/local/bin/rv ];
then
  sudo rm /usr/local/bin/rv
fi

# Gets the aboslute path to the install script and then append main.sh
MAIN_SH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/main.sh"

# Creates a symlink in /usr/local/bin/ which will allow our command to be accessible system wide.
sudo ln -s "${MAIN_SH}" /usr/local/bin/rv
