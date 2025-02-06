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

# First we need to unlink any existing clients that we linked
# in web for testing in our local environment.
echo_command "cd ~/Projects/freewill-api-v2/src/web"
cd ~/Projects/freewill-api-v2/src/web

echo_command "npm unlink --no-save @freewillpbc/client"
npm unlink --no-save @freewillpbc/client

# Now move to app and generate the new client.
echo_command "cd ~/Projects/freewill-api-v2/src/app"
cd ~/Projects/freewill-api-v2/src/app

echo_command "npm run generate-link-client"
npm run generate-link-client

# Move to web and link the new test client
echo_command "cd ~/Projects/freewill-api-v2/src/web"
cd ~/Projects/freewill-api-v2/src/web

echo_command "npm link @freewillpbc/client"
npm link @freewillpbc/client

# Drop us off back in the root of the project.
echo_command "cd ~/Projects/freewill-api-v2"
cd ~/Projects/freewill-api-v2
