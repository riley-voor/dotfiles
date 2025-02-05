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

# Move into web.
echo_command "cd ~/Projects/freewill-api-v2/src/web"
cd ~/Projects/freewill-api-v2/src/web

# Unlink the test client.
echo_command "npm unlink --no-save @freewillpbc/client"
npm unlink --no-save @freewillpbc/client

# Drop us back in the root of the project.
echo_command "cd ~/Projects/freewill-api-v2"
cd ~/Projects/freewill-api-v2
