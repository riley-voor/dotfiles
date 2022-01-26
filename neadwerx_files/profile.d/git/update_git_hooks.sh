#!/bin/bash
# This is a script to update or install the Nead Werx git hooks globally
# and inside each /var/www/vhosts/* repository

# Set the git environment variable for easy installation using templates
export GIT_TEMPLATE_DIR=/etc/profile.d/git/git-templates/

# loop through vhosts/*
# remove any hooks defined
# git init and install new hooks
for dir in /var/www/vhosts/* ; do
    if [ -d "$dir/.git/hooks" ] ; then
        hooks_dir="$dir/.git/hooks"
        rm -rf $hooks_dir/* >/dev/null 2>&1

        # go to the directory, and install the hooks
        cd "$dir"
        git init
    fi
done

# Unset the variable after we're done
unset GIT_TEMPLATE_DIR
