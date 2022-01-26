#!/bin/bash

SHELL_NAME=$(/bin/ps -p $$ -oargs=)

# only source for bash
if [[ "$SHELL_NAME" =~ "bash" ]] ; then
    function mdless () {
        pandoc -f markdown -t man --smart --normalize --standalone --toc "$*" | man -l -
    }

    # Find all files that don't contain a specific regex pattern
    # e.g.:  vnack '\bcommon_header.xml\b'
    function vnack () {
       local files=''
       local tosearch=''
       if [ $# -le 1 -a -d sql ] ; then
           # If no directories are specified, and we are in a base
           # code directory, automatically exclude wiki and sql directories
           tosearch="$(/bin/ls | grep -Ev '^(wiki|sql)$')"
           files="$(ack -L "$@" $tosearch)"
       else
           files="$(ack -L "$@")"
       fi
       if [ -z "$files" ] ; then
           echo "No matches found."
       else
           search="$(echo "$@" | sed 's/^.* //' | sed 's=/=\/=')"
           vim "+/$search" $files
       fi
    }

    # Find all files that contain a specific regex pattern
    # e.g.:  vack '\bIPM\b'
    function vack () {
       local files=''
       local tosearch=''
       if [ $# -le 1 -a -d sql ] ; then
           # If no directories are specified, and we are in a base
           # code directory, automatically exclude wiki and sql directories
           tosearch="$(/bin/ls | grep -Ev '^(wiki|sql)$')"
           files="$(ack -l "$@" $tosearch)"
       else
           files="$(ack -l "$@")"
       fi
       if [ -z "$files" ] ; then
           echo "No matches found."
       else
           search="$(echo "$@" | sed 's/^.* //' | sed 's=/=\/=')"
           vim "+/$search" $files
       fi
    }

    # Tail access log of site starting with a string
    # e.g.: taila ises   (tails access log of ises.*.merchlogix.com)
    function taila () {
        tail -f /var/log/httpd/$1*-access_log /var/log/nginx/$1*-access_log
    }

    # show short branch information for each
    # site in /var/www/vhosts (from Eddie!)
    function get_vhost_info() {
      # remember current directory
      cwd=`pwd`
      for f in /var/www/vhosts/*
      do
        HEADER_COLOR='\033[0;36m'
        C2='\033[1;36m'
        C3='\033[1;34m'
        NC='\033[0m' # No Color
        # get customer
        c=`find $f -name '\.customer' -exec cat {} \;`
        # get db info
        h=`find $f -name '\.db' -exec sed -n 1p {} \;`
        d=`find $f -name '\.db' -exec sed -n 3p {} \;`
        printf "${HEADER_COLOR}$f ${NC}($c) ${C2}$h${NC}: ${C3}$d${NC}\n"
        # change directories
        cd $f
        # show git short branch status
        git status -b -s
        # print a blank line
        echo
      done
      # return to current directory
      cd $cwd
    }

    # Tail error log of site starting with a string
    # e.g.: taile ises   (tails error log of ises.*.merchlogix.com)
    function taile () {
        tail -f /var/log/httpd/$1*-error_log /var/log/nginx/$1*-error_log /var/log/php-fpm/error.log 2>/dev/null
    }

    # With no parameters, changes into vhosts directory
    # With one parameter, changes into a subdirectory of the vhosts
    # directory that starts with that string
    # e.g.: v ises   (changes into /var/www/vhosts/ises.*.merchlogix.com)
    function v () {
        if [ -n "$1" ] ; then
            cd /var/www/vhosts/$1*
        else
            cd /var/www/vhosts
        fi
        [ -d .git ] && {
            if [ $UID -ne 0 ] ; then
                g fetch --prune
            fi
            g status
        }
    }

    # Apply Alters
    function apply_alters()
    {
        # Grab the webroot: webroot must end in '.com'
        local path=$( echo $PWD | sed 's/\(com\/\).*/\1/g')
        local test_file=""

        # Check if file path was passed in for running test mode
        if [ $1 ]; then
            test_file="--test $1"
        fi

        ~/linux_utils/apply_alters/./apply_alters.pl \
            --dbhost $( echo $( sed '1q;d' $path/.db ) ) \
            --dbname $( echo $( sed '3q;d' $path/.db ) ) \
            --new_branch $( echo $( git rev-parse --abbrev-ref HEAD ) ) \
            --path_to_sql $( echo $path/sql ) \
            --customer $( sed '1q;d' $path/.customer ) \
            --dbport $( echo $( sed '2q;d' $path/.db ) ) \
            --apply_all_unversioned \
            $test_file
    }

    # Quickly `cd` into a website. Supports tab completion
    # using the out put of `ls /var/www/vhosts`.
    function website () {
        cd "/var/www/vhosts/$1" 2> /dev/null || cd "/var/www/vhosts/${1}.chad.merchlogix.com"
    }

    # Completion function for `website`
    function _list_websites () {
        COMPREPLY=($(compgen -W "$(ls /var/www/vhosts)" "${COMP_WORDS[1]}"))
    }

    # Quickly connect to a dev database. When no args are passed in, this command
    # will do one of two things:
    # 1. If in a webroot, connect to the database in the .db file.
    # 2. If outside a webroot, connect to athena.internal with no specific database.
    #
    # A database can be manually specfied by calling `db <database name>`.
    #
    # Supports tab-completion.
    function db () {
        local hostname="athena.internal"
        local port="6432"
        local db="$1"

        if [[ -z "$db" && "$PWD" =~ ^(/var/www/vhosts/[[:alnum:].-]+)/? ]]; then
            local root_dir="${BASH_REMATCH[1]}"
            db_arr=($(head -n 3 "$root_dir/.db"))

            hostname="$(echo -e "${db_arr[0]}" | sed -e 's/[[:space:]]*$//')"
            port="$(echo -e "${db_arr[1]}" | sed -e 's/[[:space:]]*$//')"
            db="$(echo -e "${db_arr[2]}" | sed -e 's/[[:space:]]*$//')"
        fi

        psql -h "$hostname" -U postgres -p "$port" -d "$db"
    }

    # Completion function for `db`
    function _list_dbs () {
        local hostname="athena.internal"
        local port="6432"

        if [[ -z "$db" && "$PWD" =~ ^(/var/www/vhosts/[[:alnum:].-]+)/? ]]; then
            local root_dir="${BASH_REMATCH[1]}"
            db_arr=($(head -n 2 "$root_dir/.db"))

            hostname="${db_arr[0]}"
            port="${db_arr[1]}"
        fi

        local dbtbl="$(psql -h ${hostname} -U postgres -p ${port} -l)"
        local db_names=()
        local old_ifs=$IFS

        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ "$line" =~ ^\ ([[:alnum:]_.-]+)[[:space:]]+\|\ postgres.+ ]]; then
                db_names+=("${BASH_REMATCH[1]}")
            fi
        done <<< "$dbtbl"

        IFS=$old_ifs
        COMPREPLY=($(compgen -W "${db_names[*]}" "${COMP_WORDS[1]}"))
    }

    # Quickly run apply_alters with minimal typing. Must be run in a webroot.
    #
    # If run with no args, this function will intelligently try to determine
    # the correct alters to apply. For example, in a versioned branch, it will
    # apply alters up to the version checked out. In a feature branch, it will
    # apply unversioned alters.
    #
    # The version to apply can manually be specified by passing in -v <version>.
    # The -v param can also be used to apply versioned alters to an unversioned
    # database.
    #
    # Unversioned alters can manually be specified by passing in -u. In versioned
    # branches, this flag will be ignored unless the -f flag is also passed in.
    #
    # Passing in -d will apply deferred alters.
    function aa2 () {
        local force_unversioned=0
        local apply_all_unversioned=''
        local apply_version=''
        local apply_deferred=''

        local OPTIND u v f d

        while getopts "uv:fd" opt; do
            case "$opt" in
                u)
                    apply_all_unversioned="--apply_all_unversioned"
                    ;;
                v)
                    apply_version="$OPTARG"
                    ;;
                f)
                    force_unversioned=1
                    ;;
                d)
                    apply_deferred="--apply_deferred"
                    ;;
                *)
                    echo "Usage: aa2 [args]"
                    echo "  Args:"
                    echo "    -v <version> - apply alters up to the specific version specified by -v."
                    echo "    -u           - apply all unversioned alters (forcefully if desired)."
                    echo "    -f           - force unversioned alters to be applied even in a versioned branch."
                    return
                    ;;
            esac
        done

        shift "$((OPTIND-1))"

        if [[ "$PWD" =~ ^(/var/www/vhosts/[[:alnum:].-]+)/? ]]; then
            local root_dir="${BASH_REMATCH[1]}"
        else
            echo "Cannot be run outside an XERP webroot."
            return
        fi

        local customer=$(head -n 1 "$root_dir/.customer")
        local db_arr=($(head -n 3 "$root_dir/.db"))
        local branch=$(g branch | grep \* | cut -d ' ' -f2)

        local hostname="$(echo -e "${db_arr[0]}" | sed -e 's/[[:space:]]*$//')"
        local port="$(echo -e "${db_arr[1]}" | sed -e 's/[[:space:]]*$//')"
        local db="$(echo -e "${db_arr[2]}" | sed -e 's/[[:space:]]*$//')"

        if [[ "$branch" =~ ^(bug_)?(v[[:digit:]]+[.](([0-1][[:digit:]])|(2[0-6])))(_XERP-[[:digit:]]+)?$ ]]; then
            # Force branch to be version v-whatever and do not apply unversioned alters
            branch="${BASH_REMATCH[2]}"

            if [[ $force_unversioned -eq 0 ]]; then
                apply_all_unversioned=''
            fi
        elif [[ ! -z "$apply_version" ]]; then
            branch="$apply_version"
        fi

        if [[ ! -z "$apply_all_unversioned" ]]; then
            echo 'Will apply unversioned alters.'
        fi

        if [[ ! -z "$apply_deferred" ]]; then
            echo 'Will apply deferred alters.'
        fi

        echo "Applying $branch alters for $customer to $db@$hostname:6432..."

        ~/linux_utils/apply_alters/apply_alters.pl \
            --dbhost "$hostname" \
            --dbname "$db" \
            --dbport 6432 \
            --new_branch "$branch" \
            "$apply_all_unversioned" \
            "$apply_deferred" \
            --path_to_sql "$root_dir/sql" \
            --customer "$customer"
    }

    complete -F _list_websites website
    complete -F _list_dbs db

    alias aa=apply_alters

    # add standards/scripts/ to the path and
    PATH=$PATH:/etc/profile.d/scripts/:/usr/pgsql-13/bin

    HISTFILESIZE=100000
fi
