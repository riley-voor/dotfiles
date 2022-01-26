#!/bin/bash

# A handful of useful functions

# enforcement file to ensure that the commit hooks are run
# and saving the commit hook results
_commit_hook_enforce_file='.COMMIT_HOOKS_ENFORCE'

# abort the current commit
function abort_commit () {
    echo ""
    color_echo red "Aborting commit at user's request!"
    exit 1
}

# exit now
function fatal_error () {
    exit 3
}

# echos out with color, e.g.
#   color_echo red "My Error"
#   color_echo yellow "My Warning"
#   color_echo green "My Success"
function color_echo() {
    case $1 in
     red)
          color="1;31"
          ;;
     green)
          color="1;32"
          ;;
     yellow)
          color="1;33"
          ;;
     blue)
         color="1;34"
         ;;
     purple)
         color="1;35"
         ;;
     cyan)
         color="1;36"
         ;;
     white)
         color="0"
         ;;
     *)
          color=$1
          ;;
    esac

    # remove $1
    shift

    echo -e "\033[${color}m$@\033[0m"
}

# begin reading from the keyboard
function turn_on_keyboard () {
    # save stdin to fd 6
    exec 6<&1

    # set stdin to /dev/tty
    exec </dev/tty

    # because we're about to read something...I guess
    flush_stdin
}

# stop reading from the keyboard
function turn_off_keyboard () {
    # restore stdin from fd 6 and close fd 6
    exec 1<&6 6>&-
}

# asks the user for input in the form of a question
# the result is stored in the variable $ANSWER
function q () {
    question="$1"

    # manually run color echo without a newline
    echo -e -n "\033[1;33m$question \033[0m"

    turn_on_keyboard
    read ANSWER
    turn_off_keyboard

    # add the missing newline
    echo ""
}

# [see: https://superuser.com/questions/276531/clear-stdin-before-reading]
function flush_stdin() {
    while read -e -t 0.1 ; do : ; done
}

# asks the user for input in the form of a [y/n] question
# the result is stored in the variable $ANSWER
function ask () {
    question="$1"

    # manually run color echo without a newline
    echo -e -n "\033[1;33m$question [y/n]: \033[0m"

    turn_on_keyboard
    read -n 1 ANSWER
    turn_off_keyboard

    # add the missing newline
    echo ""

    # loop until the user responds with a y or n
    while [[ $ANSWER != y ]] && [[ $ANSWER != n ]] ; do
        # manually run color echo without a newline
        echo -e -n "\033[1;33m[y/n]: \033[0m"

        turn_on_keyboard
        read -n 1 ANSWER
        turn_off_keyboard

        # add the missing newline
        echo ""
    done
}

# asks the user for input in the form of a [y/n] question
# the result is stored in the variable $ANSWER
function ask_with_timeout () {
    timeout="$1"
    default="$2"
    question="$3"

    # manually run color echo without a newline
    color_echo yellow "$question [y/n]"
    echo -e -n "\033[1;33mAssuming \"$default\" in $timeout secs: \033[0m"

    turn_on_keyboard
    read -t $timeout -n 1 ANSWER
    read_exit_code="$?"
    turn_off_keyboard

    # add the missing newline
    echo ""

    if [[ $read_exit_code != 0 ]] ; then
        # timeout occurred
        ANSWER="$default"
    else
        # loop until the user responds with a y or n
        while [[ $ANSWER != y ]] && [[ $ANSWER != n ]] ; do
            # manually run color echo without a newline
            echo -e -n "\033[1;33m[y/n]: \033[0m"

            turn_on_keyboard
            read -n 1 ANSWER
            turn_off_keyboard

            # add the missing newline
            echo ""
        done
    fi
}

# Matches an element against an array of bash regexes
# return status is 0 if it matched, 1 if not, e.g.
#   declare -a my_array=(
#       'v[0-9].[0-9]+HF'
#   )
#
#   matches_regex_element "$element" "${my_array[@]}"
#   if [[ $? == 0 ]] ; then
#       echo "Element matched"
#   fi
matches_regex_element () {
    for element in "${@:2}" ; do
        if [[ "$1" =~ $element ]] ; then
            return 0
        fi
    done

    return 1
}

# Matches an element against an array of bash globs
# return status is 0 if it matched, 1 if not, e.g.
#   declare -a my_array=(
#       '*test/*'
#       '*common/barcode/*'
#       '*common/dompdf/*'
#       '*common/simplesaml/*'
#   )
#
#   matches_glob_element "$element" "${my_array[@]}"
#   if [[ $? == 0 ]] ; then
#       echo "Element matched"
#   fi
matches_glob_element () {
    for element in "${@:2}" ; do
        if [[ $1 == $element ]] ; then
            return 0
        fi
    done

    return 1
}

# Run at the start of a commit hook to check the repo and merge commit status
# and decide if the hooks should continue to run.
exit_if_commit_hooks_should_not_run () {
    repo_name=`basename $(git remote show -n origin | grep Push | cut -d: -f2-) .git`

    declare -a check_repos=(
        'xerp'
        'kirktest'
        'workflow_testing'
    )

    matches_glob_element "$repo_name" "${check_repos[@]}"
    if [[ $? != 0 ]] ; then
        color_echo yellow "Ignoring commit hooks for repo '$repo_name'"
        exit 0
    fi

    # test for merge commit
    if [[ -f ".git/MERGE_HEAD" ]] || [[ -f ".git/MERGE_MSG" ]] ; then
        color_echo yellow "Ignoring commit hooks for merge commit"
        exit 0
    fi
}

# prints a list of files, each with the given prefix
# the files should be from the form:
#   files=`ag ...`
#   files=`ls ...`
#   files=`find ...`
print_files () {
    prefix="$1"
    shift
    files="$@"

    for file in $files ; do
        echo -e $prefix $file
    done
}

# prints a list of lines, each with the given prefix
print_lines () {
    prefix="$1"
    shift

    while read -r line ; do
        echo -e $prefix $line
    done <<< "$@"
}

# gets the name of the current git branch
get_current_branch () {
    branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`

    if [ "$branch" = "HEAD" ]; then
        # check if we are in a rebase
        head_name_file="$(git rev-parse --git-dir)/rebase-merge/head-name"
        if [ -f "${head_name_file}" ]; then
            branch=$(cut -f3- -d/ $head_name_file)
        else
            branch="DETACHED HEAD"
        fi
    fi

    echo $branch
}
