# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source global apple definitions
if [ -f /etc/bashrc_Apple_Terminal ]; then
	. /etc/bashrc_Apple_Terminal
fi

# Source git auto-complete script
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# Gotta put this here in order to get typescript/node/npm/etc working properly.
export PATH=/usr/local/bin:$PATH
export PATH=./node_modules/.bin:$PATH

# Source bash completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
#export SYSTEMD_PAGER=

# puts files listed as trailing arguments into tabs rather than windows
alias vim="vim -p"

# shorter shortcut for vimmodified
vimmod () {
  vimmodified $1
}

# vim shortcut alias that opens all the files that 'git status' lists as modified
# TODO update this to tell you "theres no modified files" if it doesn't find any files to open.
# TODO update this so when you've added new files in a new directory, it opens the files rather than just the directory.
vimmodified() {
  print_usage() {
    printf "Only acceptable flag is the optional \"-a\" flag which (includes all files instead of only modified ones)"
  }

  # Get the -a param to figure out if we are only opening modified files or if we are also including untracked files.
  # NOTE: this param getting is pretty clunky and could defs be improved at some later date.
  ALL_FILES_FLAG='false'
  FIRST_PARAM=$1

  if [[ -n $FIRST_PARAM ]];
  then
    if [ $FIRST_PARAM != '-a' ];
    then
      print_usage
    else
      ALL_FILES_FLAG='true'
    fi
  fi

  # Make sure we're in a git repo before proceeding.
  if [[ `git status --porcelain` ]]; then
      CURRENT_DIRECTORY=$(pwd)

      ROOT_DIRECTORY=$(git rev-parse --show-toplevel)

      # Check if we're in the root. If we are then run the simple version of the command.
      if [ $CURRENT_DIRECTORY = $ROOT_DIRECTORY ];
      then
        if [ "$ALL_FILES_FLAG" = true ];
        then
          vim $(git status --porcelain | awk '{print $2}')
        else
          vim $(git status --porcelain | grep ' M ' | awk '{print $2}')
        fi
      else
        # If we're not in the root then we need to find the part of the file path that our
        # current directory has that the root directory doesn't have so we know how far back
        # up the directories we need to g.
        regex="^${ROOT_DIRECTORY}(.*)$"
        if [[ $CURRENT_DIRECTORY =~ $regex ]];
        then
          # Pull out the difference between our current dir and the root dir.
          CURRENT_DIRECTORY_DIFF="${BASH_REMATCH[1]}"

          # Count how many levels that is.
          CURRENT_DIRECTORY_DIFF_LEVELS_COUNT=$(echo $CURRENT_DIRECTORY_DIFF | sed 's.[^/]..g' | awk '{print length;}')

          # Build the "../../../etc" string that we'll prepend to our file names when we actually call vim.
          FILE_PREFIX=''
          for (( i=0; i<$CURRENT_DIRECTORY_DIFF_LEVELS_COUNT; ++i ));
          do
            FILE_PREFIX="${FILE_PREFIX}../"
          done

          # Make sure to add backslashes to our file prefix so we can pass it into sed later.
          FILE_PREFIX_ESCAPED=$(echo $FILE_PREFIX | sed 's.\/.\\/.g')
        else
          # Hypothetically this should never happen. If it does then we are somehow inside a git
          # repo but our current directory doesn't contain the root directory of the git repo.
          # That should be impossible so we just exit out just in case.
          echo 'SOMETHING WENT WRONG'
          exit 1
        fi

        # Actually call vim with all our files but prepend our escaped file prefix so we actually
        # find the files relative to our current directory.
        if [ "$ALL_FILES_FLAG" = true ];
        then
          vim $(git status --porcelain | awk '{print $2}' | sed "s/^/${FILE_PREFIX_ESCAPED}/")
        else
          vim $(git status --porcelain | grep ' M ' | awk '{print $2}' | sed "s/^/${FILE_PREFIX_ESCAPED}/")
        fi
      fi
  fi
}

# Opens a file based on its name by recursively searching
# through the current directory to find said file.
vimfind() {
  ~/scripts/open_file_in_vim_by_name_search.sh $1 $2
}

# Opens vim to the location of a the specified ctag.
vimtag() {
  vim -t $1
}

# cd shortenings
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..7="cd ../../../../../../.."
alias ..8="cd ../../../../../../../.."
alias ..9="cd ../../../../../../../../.."

# quality of life aliases
alias g="git"
alias e="exit"
alias la="ls -a"
alias ll="ls -l"
alias ls="ls --color"

# alias for moving to my local freewill repo and starting up a tmux session
alias fwstart="~/scripts/start_freewill_tmux_coding_session.sh"
alias fwstop="tmux kill-session -t coding"
alias fwupdaterepo="~/scripts/keep_freewill_repo_up_to_date.sh"
alias fwupdatedb="~/scripts/keep_freewill_local_db_update_to_date.sh"

# aliases for freewill repo git management
alias fwmerge="~/scripts/merge_updated_develop_into_current_branch.sh"
alias fwee="~/scripts/set_freewill_ephemeral_environment_to_current_branch.sh"
fwnewbranch() {
    ~/scripts/create_new_clean_freewill_branch.sh $1
}

# aliases for managing api client test/prod versions.
alias fwinstallprodclient="~/scripts/install_prod_client.sh"
alias fwnewlinkclient="~/scripts/generate_and_link_new_api_link_client.sh"
alias fwremovelinkclient="~/scripts/remove_api_link_client.sh"
alias fwcleanbranches="~/scripts/clean_up_orphaned_local_git_branches.sh"

# TODO maybe write a script that auto pulls the uat db and updates your local db to match it (probably it should also auto-create a backup of your existing local db) (see the src/app/db/ readme for details on how to do this. (also gonna want to recreate my local account for my dev environment when I do this because otherwise itll get overwritten by the uat pull)

# Quick little helper to clear the logs tailing pane if it
# has stuff in it that I don't wanna see anymore.
hidelogs() {
  for i in {1..20};
  do
    tmux send-keys -t 2 "Enter"
  done
}

# Fixes postgres after it has been shutdown improperly maybe by a
# crash or just not closing tmux before I shut down my laptop.
fixpostgres() {
  rm /opt/homebrew/var/postgres/postmaster.pid
  brew services restart postgres
}


# aliases for ease of navigation inside freewill repo.
alias root="cd ~/Projects/freewill-api-v2/"
alias app="cd ~/Projects/freewill-api-v2/src/app/"
alias web="cd ~/Projects/freewill-api-v2/src/web/"
alias pdf="cd ~/Projects/freewill-api-v2/src/pdf/"
alias pdfv1="cd ~/Projects/freewill-api-v2/src/pdfv1/"
alias admin="cd ~/Projects/freewill-api-v2/src/admin-console/"
alias portal="cd ~/Projects/freewill-api-v2/src/portal/"
alias crypto="cd ~/Projects/freewill-api-v2/src/crypto-web/"
alias header="cd ~/Projects/freewill-api-v2/src/headerAppender/"
alias prerender="cd ~/Projects/freewill-api-v2/src/prerender/"
alias estately="cd ~/Projects/freewill-api-v2/src/estately-portal/"

# alias for command that logs you into aws via command line for lambda or serverless stuff or something.
# NOTE: might want to run "export AWS_REGION=us-west-2" after you execute this alias depending on what you want to test.
alias fwawslogin="aws-google-auth --bg-response js_enabled -a --no-cache -I C01oqm4zv -R us-west-2 -S 599960580392 -u riley@freewill.com && export AWS_PROFILE=sts"
# NOTE: if this outputs a little json lookin thing that has your email in it and "sts" and such then you are successfully logged in to aws.
alias fwtestloginsuccess="aws sts get-caller-identity"

# now i can run "athena thd" and connect to the thd db on the athena host
athena() {
    pgcli -U postgres -h athena -d $1
}

# make multitail behave like the taile script did
mtaile() {
    multitail --mergeall /var/log/httpd/$1*-error_log
}

# Custom tail command for seeing all the local fw npm/node error logs.
fwtaillogs() {
    # These are the lines we want to hide from our tail output because they are always
    # going to be there, aren't helpful, and don't hurt anything.
    # We make sure to let them actually go to the error log files so we can see them
    # if we really need them though.
    LINES_TO_HIDE=(
      'Debugger listening on ws://127.0.0.1:9229/'
      'For help, see: https://nodejs.org/en/docs/inspector'
      'Starting inspector on 127.0.0.1:9229 failed: address already in use'
      'Debugger ending on ws://127.0.0.1:9229/'
      'ANY /.* (λ: app)'
      '(λ: app) RequestId: .* Duration: \d+(\.\d+)? ms  Billed Duration: \d+(\.\d+)? ms'
      '(λ: app) RequestId: .*  Duration: .* ms  Billed Duration: .* ms'
      '<s> \[webpack.Progress\] .*'
      'Server ready: https://0.0.0.0:.*'
      'Offline \[http for lambda\] listening on https://0.0.0.0:.*'
    )

    # Build the string we are going to pass to grep that filters out the lines we don't want to see.
    GREP_PARAM=${LINES_TO_HIDE[0]}
    for ((i = 0; i< ${#LINES_TO_HIDE[@]}; i++))
    do
      if [[ $i != 0 ]];
      then
        # "\|" is what grep needs to see to do the "or" operation
        GREP_PARAM="${GREP_PARAM}\|${LINES_TO_HIDE[${i}]}"
      fi
    done

    # -v is the param that tells grep to do the "not" operator.
    # That perl command replaces multiple blank lines with a single blank line.
    tail -f ~/fw_error_logs/*.log 2>/dev/null | grep -v "${GREP_PARAM}" --line-buffered | perl -00 -pe ''
}

alias fwclearlogs="echo -n '' | tee ~/fw_error_logs/*.log >/dev/null"

alias pgcli-fw-local="pgcli -U postgres -h 127.0.0.1 -d freewill_dev"
alias pgcli-fw-uat="pgcli -U riley -h freewill-clusteruat.cy38snaamnvp.us-west-2.rds.amazonaws.com -p 5432 -d uat"
alias pgcli-fw-prod="pgcli -U riley -h freewill-prod-v2.cy38snaamnvp.us-west-2.rds.amazonaws.com -p 5432 -d thanos"
alias pgcli-fw-ee="pgcli -U riley -h freewill-clusterthree.cy38snaamnvp.us-west-2.rds.amazonaws.com -p 5432 -d riley"
alias pgcli-fw-integrations="pgcli -U svc_freewill_api -h freewill-dms-replica.cy38snaamnvp.us-west-2.rds.amazonaws.com -p 5432 -d productionreplica"

# Make sure we're using exuberent ctags rather than the default MacOS ctags
alias ctags='/opt/homebrew/bin/ctags'

# enable globstar for easy recursive directory commands
# globstar is the ** thing that includes directories and subdirectories
# recursively in a glob
shopt -s globstar

# custom git bash prompt stuff
function git_bash_prompt_section() {
	# get current branch name
	#BRANCHNAME=$(git rev-parse --abbrev-ref HEAD)
	BRANCHNAME=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

	# return empty string if we aren't in a git repo
	RETURNVAL=""

	# check if we successfully got a git branch
	if [[ "$BRANCHNAME" =~ [a-z][a-z]* ]]; then
		STATUSINDICATORS=" "

		# check for unstaged changes
		if [[ "$(git status)" =~ Changes.not.staged.for.commit ]]; then
			STATUSINDICATORS="$STATUSINDICATORS*"
		fi

		# check for staged but uncommitted changes
		if [[ "$(git status)" =~ Changes.to.be.committed ]]; then
			STATUSINDICATORS="$STATUSINDICATORS+"
		fi

		# check for committed but unpushed changes
		if [[ "$(git status)" =~ branch.is.ahead ]]; then
			STATUSINDICATORS="$STATUSINDICATORS!"
		fi

		# check if we have any status indicators
		if [[ "$STATUSINDICATORS" =~ [/*/+/!] ]]; then
			RETURNVAL="$BRANCHNAME$STATUSINDICATORS"
		else
			RETURNVAL="$BRANCHNAME"
		fi

		# add parenthesis around return val
		RETURNVAL="($RETURNVAL)"
	fi

	echo $RETURNVAL
}

# custom bg process bash prompt stuff
function bg_proc_bash_prompt_section() {
	# return empty string if we don't have any background processes initiated by this shell.
	RETURNVAL=""

  # Grab the stopped bg processes.
  # NOTE: the "jobs" command only shows the backgrounded processes that were initiated
  # by this specific shell instance. And that's exactly what we want here.
	BG_PROCS=$(jobs | grep Stopped 2> /dev/null)

  if [[ "$BG_PROCS" =~ [a-z][a-z]* ]]; then
    BG_PROCS=(${BG_PROCS})

    BG_PROC_COMMAND=${BG_PROCS[2]}

    # If we have a script name or some other weird case where the actual proc name isn't
    # as helpful as we'd like it to be, we substitute it here for the more useful name.
    if [[ $BG_PROC_COMMAND == '~/scripts/open_file_in_vim_by_name_search.sh' ]]; then
      BG_PROC_COMMAND='vim'
    fi

    RETURNVAL="[${BG_PROC_COMMAND}]"
  fi

	echo $RETURNVAL
}

# TODO maybe this character? ◣, ▶, ⮀
# TODO testing
# TODO maybe update the prompt to show when you've backgrounded a process
# TODO maybe update the prompt to show when you have items in your git stash
PS1='\033[0;32m\u@\h\033[m\033[1;34m \w\033[m\033[0;32m $(git_bash_prompt_section)\033[m\033[0;33m $(bg_proc_bash_prompt_section)\033[m\033[1;34m\n\$ '
#PS1='\e[1;35m\e[48;5;147m \u@\h \e[m\e[1;34m \w \e[1;32m $(git_bash_prompt_section) \e[m\e[1;34m\n\$ '
#PS1='\[\033[0;32;1;40m\]\u@\h\[\033[01;34m\] \w\[\033[0;32;1;40m\] $(git_bash_prompt_section)\[\033[01;34;0;0m\]\n\$ '

# Have bash set the output color to "normal color" after you enter a command into the
# prompt. That way your prompt coloring won't color the output of the command until its overwritten.
trap "echo -n \"$(tput sgr0)\"" DEBUG

# for ssh-ing into audrey's personal server where we host audreyflix
alias sshaudreyflix="ssh -t riley@www.audreyflix.com \"bash\""

# for compiling C++ with warnings and errors and so on
function compilecpp() {
    g++ -Wall -Wextra -Werror -o $1.out $1.cpp 
}
export -f compilecpp
