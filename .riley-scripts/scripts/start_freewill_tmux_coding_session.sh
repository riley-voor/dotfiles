#!/bin/sh
#
# Setup a work space called `coding` with one window.
# The window has 3 panes.
# The first pane set at 65%, split horizontally, set to pull git and show the status of the repo.
# pane 2 is split at 50% vertically and pulls up the database access.
# pane 3 is set to tail the logs of the node servers.
# NOTE: some of the "send-keys" commands use aliases set up in ~/.bashrc
session="coding"

# set up tmux
tmux start-server

# Check if the session exists, discarding output
# We can check $? for the exit status (zero for success, non-zero for failure)
tmux has-session -t $session 2>/dev/null

if [ $? == 0 ]; then
    # Check if you want to kill the existing session
    while true; do
        read -p "There already exists a tmux session with the name \"$session\". Do you wish to kill that session and proceed? [y/n]: " yn
        case $yn in
            [Yy]* ) tmux kill-session -t $session; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer y or n.";;
        esac
    done
fi

# Move to the freewill repo directory.
cd ~/Projects/freewill-api-v2

# Get the size of the terminal window so we can set the tmux session windows size.
# $1 = rows, $2 = columns
set -- $(stty size)
# create a new tmux session, starting vim from a saved session in the new window
tmux -2 new-session -d -s "$session" -x "$2" -y "$(($1 - 1))"

# Select pane 0, set dir to api, run vim
#tmux selectp -t 0
# TODO maybe make this fancier to have it pull develop specifically and then merge it into your current branch
# Running npm install from the src/ directory will run npm install for all the sub project directories.
# TODO Make sure that we do all of this npm installing on the up-to-date develop branch and then do our merging into our current working branch.
tmux send-keys "fwupdaterepo" C-m

# Split pane 0 vertically
tmux splitw -v
tmux resizep -t{bottom} -y "47%"
# set pane 1, to start pgcli
tmux send-keys "sleep 10" C-m # we do this because sometimes the postgres process needs time to start up.
tmux send-keys "fwupdatedb -c" C-m

# Split pane 1 vertiacally
tmux splitw -v
tmux resizep -t{bottom} -y "29%"

# select pane 2, clear logs then set to tail logs
#tmux selectp -t 2
tmux send-keys "fwclearlogs" C-m
tmux send-keys "clear" C-m
tmux send-keys "fwtaillogs" C-m

# Split pane 2 vertically
tmux splitw -v
tmux resizep -t{bottom} -y "14%"

# start up htop
tmux send-keys "htop" C-m

# make new window for launching node servers
tmux new-window -t $session:1

# start app node server
tmux send-keys "cd src/app/" C-m
tmux send-keys "npm run start-inspect 2> ~/fw_error_logs/app.log" C-m

# Split pane 0 horizontal
tmux splitw -h

# start portal node server
tmux send-keys "cd src/portal/" C-m
tmux send-keys "NO_BROWSER=true npm run start 2> ~/fw_error_logs/portal.log" C-m

# Split pane 2 vertiaclly
# NOTE: we did 49 here because the 50% split is slightly uneven and this side of that
# split looks slightly better than where it falls if we try to split by exactly 50%.
tmux splitw -v

# start pdf node server
tmux send-keys "cd src/pdf/" C-m
tmux send-keys "npm run start 2> ~/fw_error_logs/pdf.log" C-m

# Split pane 1 vertically
tmux splitw -v

# start pdfv1 node server
tmux send-keys "cd src/pdfv1/" C-m
tmux send-keys "npm run start 2> ~/fw_error_logs/pdfv1.log" C-m

# Select pane 0
tmux selectp -t 0

# Split pane 0 vertically
tmux splitw -v

# start web node server
tmux send-keys "cd src/web/" C-m
tmux send-keys "NO_BROWSER=true npm run start-no-progress-logging-no-browser 2> ~/fw_error_logs/web.log" C-m

# Select pane 0 in the first window
tmux select-window -t $session:0
tmux selectp -t 1 # setup pane 1 as the one I previously selected so my cursor will move there by default when I switch panes
tmux selectp -t 0

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
