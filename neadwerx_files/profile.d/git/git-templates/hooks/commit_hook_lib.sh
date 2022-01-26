#!/bin/bash

# library for commit hook functions and behaviours

# grab the passed commit hook name
_commit_hook_name="$1"
shift

# global check to see if the current executing commit hook had errors
_commit_hook_had_errors=false

# 70 char seperator for commit errors
_commit_error_sep="----------------------------------------------------------------------------------------"

# used to check if commit hooks can be skipped
_commit_hook_changes_hash=`date +%s`

# used to check if commit hooks can be skipped
_commit_hook_hash_file=".COMMIT_HOOK_HASH_LAST"

# exit the current commit hook
function hook_exit () {
    exit_code=${1:-0}

    # save the commit hook hash to a file so we can retrieve it on the other side
    echo "$_commit_hook_changes_hash" > $GIT_DIR/$_commit_hook_hash_file

    if [[ -n "$_commit_last_sep_output_color" ]] ; then
        # a sep was printed, so close it out
        color_echo $_commit_last_sep_output_color "----------$_commit_error_sep"
    fi

    if [[ $_commit_hook_had_errors == true ]] ; then
        exit 1
    else
        exit $exit_code
    fi
}

# mark the current commit hook as having an error, and
# re-echos out all passed lines with an indentation added
function hook_error () {
    _commit_hook_had_errors=true
    _commit_last_sep_output_color=red

    color_echo red "-ERROR----$_commit_error_sep"
    local IFS=$'\n'
    for line in $@ ; do
        echo -e "\t$line"
    done
}

# re-echos out all passed lines with an indentation added
function hook_warn () {
    _commit_hook_had_warn=true
    _commit_last_sep_output_color=yellow

    color_echo yellow "-WARN-----$_commit_error_sep"
    local IFS=$'\n'
    for line in $@ ; do
        echo -e "\t$line"
    done
}

# re-echos out all passed lines with an indentation added
function hook_info () {
    _commit_hook_had_info=true
    _commit_last_sep_output_color=white

    echo "-INFO-----$_commit_error_sep"
    local IFS=$'\n'
    for line in $@ ; do
        echo -e "\t$line"
    done
}

# fail the current commit hook
function hook_fail () {
    _commit_hook_had_errors=true

    hook_exit
}

# set the changes hash to be the value provided
# this will be used to check if a hook can be skipped
# during the next commit attempt
hook_set_changes_hash () {
    _commit_hook_changes_hash=`echo "$@" | shasum | cut -d' ' -f1 | tr -d '\n'`
}

# skip and use the results of the old commit hook
# if the given sha matches the recorded sha
skip_hook_if_record_matches () {
    # if there's a record for the currently running commit hook
    commit_record=`grep -P "^$_commit_hook_name:" $GIT_DIR/$_commit_hook_enforce_file`
    if [[ -n "$commit_record" ]] ; then
        # get the old sha from the record
        old_sha=`echo "$commit_record" | cut -d':' -f2`

        # if the shas match
        if [[ "$old_sha" == "$_commit_hook_changes_hash" ]] ; then
            # skip the commit hook
            exit 2 # special return code to check on the other side o_O
        fi
    fi
}

# Retrieves the staged files to check based upon:
#   - grep regex:  regex (see grep -P)
#   - diff filter: string (see git help diff) (optional)
# If the requested files have unstaged changes then
# exit the hook and claim a failure.
get_files_to_check () {
    # save the return var name
    local __return_var="$1"
    shift

    regex="$1"
    filter="$2"

    declare -a ignore_files=(
        '*common/barcode/*'
        '*common/dompdf/*'
        '*common/simplesaml/*'
        '*qa/vendor/bundle/*'
        '*/vendor/*'
        '*/aws_sdk/*'
        '*/google_api/*'
        '*common/fonts*'
    )

    # if the regex is missing, then report an error,
    # skip the git hook, and continue the commit process.
    if [[ -z "$regex" ]] ; then
        color_echo red "Failed to get files, contact <kirk@merchlogix.com>"
        fatal_error
    fi

    if [[ -z "$filter" ]] ; then
        filter_arg=" "
    else
        filter_arg=" --diff-filter=$filter "
    fi

    possible_staged_files=`git diff --find-copies=90% --name-only $filter_arg --staged | grep -P "$regex"`
    possible_unstaged_files=`git diff --find-copies=90% --name-only $filter_arg | grep -P "$regex"`

    declare -a staged_files=()
    for possible_staged_file in $possible_staged_files ; do
        matches_glob_element "$possible_staged_file" "${ignore_files[@]}"
        if [[ $? != 0 ]] ; then
            staged_files+=($possible_staged_file)
        fi
    done

    declare -a unstaged_files=()
    for possible_unstaged_file in $possible_unstaged_files ; do
        matches_glob_element "$possible_unstaged_file" "${ignore_files[@]}"
        if [[ $? != 0 ]] ; then
            unstaged_files+=($possible_unstaged_file)
        fi
    done

    # check all the staged files to see if they have any unstaged changes,
    # if so then we should stop the commit process because the user
    # most likely forgot to add the changes to the commit after making an
    # fix. Thus we fail the commit and tell the user.
    for staged_file in ${staged_files[@]} ; do
        matches_glob_element "$staged_file" "${unstaged_files[@]}"
        if [[ $? == 0 ]] ; then
            hook_warn "$(
                color_echo red "\tAttempted to run a commit hook against a file that has unstaged changes."
                color_echo red "\tPlease stage these changes and attempt to commit again."
                color_echo yellow "\tOffending file: $staged_file"
            )"

            hook_exit 3
        fi
    done

    # finally return the staged files by setting
    # the given return var in the global scope
    eval $__return_var="'${staged_files[@]}'"
}

# Retrieves the committed files to check based upon:
#   - commit sha: the sha of the commit to diff
#   - grep regex:  regex (see grep -P)
#   - diff filter: string (see git help diff) (optional)
get_files_from_commit () {
    # save the return var name
    local __return_var="$1"
    shift

    commit="$1"
    regex="$2"
    filter="$3"

    declare -a ignore_files=(
        '*common/barcode/*'
        '*common/dompdf/*'
        '*common/simplesaml/*'
        '*qa/vendor/bundle/*'
        '*/vendor/*'
        '*/aws_sdk/*'
        '*/google_api/*'
        '*common/fonts*'
    )

    # if the regex is missing, then report an error,
    # skip the git hook, and continue the commit process.
    if [[ -z "$regex" ]] ; then
        color_echo red "Failed to get files, contact <kirk@merchlogix.com>"
        fatal_error
    fi

    if [[ -z "$filter" ]] ; then
        filter_arg=" "
    else
        filter_arg=" --diff-filter=$filter "
    fi

    possible_changed_files=`git diff --find-copies=90% --name-only "$commit" "$commit~1" $filter_arg | grep -P "$regex"`

    declare -a changed_files=()
    for possible_changed_file in $possible_changed_files ; do
        matches_glob_element "$possible_changed_file" "${ignore_files[@]}"
        if [[ $? != 0 ]] ; then
            changed_files+=($possible_changed_file)
        fi
    done

    # finally return the changed files by setting
    # the given return var in the global scope
    eval $__return_var="'${changed_files[@]}'"
}
