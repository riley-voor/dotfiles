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

# TODO update this for linux
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

# TODO move this to riley_utils
# vim shortcut alias that opens all the files that 'git status' lists as modified
# TODO update this to tell you "theres no modified files" if it doesn't find any files to open.
# TODO update this so when you've added new files in a new directory, it opens the files rather than just the directory.
vimmodified() {
  print_usage() {
    printf "Only acceptable flag is the optional \"-a\" flag which (includes untracked files as well as modified ones)"
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
  rv vim-find $1 $2
}

# TODO move this to riley_utils
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

# TODO gotta move this to riley_utils
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
  # TODO gotta update this to work on linux
  rm /opt/homebrew/var/postgres/postmaster.pid
  brew services restart postgres
}

# TODO gotta move this to riley_utils
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

# TODO gotta move this to riley_utils
alias fwclearlogs="echo -n '' | tee ~/fw_error_logs/*.log >/dev/null"

# Make sure we're using exuberent ctags rather than the default MacOS ctags
# TODO gotta figure out whether we need this or something like it for linux once we see if we can get vim ctags working again.
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
    if [[ $BG_PROC_COMMAND == '~/.riley_scripts/open_file_in_vim_by_name_search.sh' ]]; then
      BG_PROC_COMMAND='vim'
    fi

    RETURNVAL="[${BG_PROC_COMMAND}]"
  fi

	echo $RETURNVAL
}

# TODO maybe this character? ◣, ▶, ⮀
# TODO maybe update the prompt to show when you have items in your git stash
PS1='\033[0;32m\u@\h\033[m\033[1;34m \w\033[m\033[0;32m $(git_bash_prompt_section)\033[m\033[0;33m $(bg_proc_bash_prompt_section)\033[m\033[1;34m\n\$ '
#PS1='\e[1;35m\e[48;5;147m \u@\h \e[m\e[1;34m \w \e[1;32m $(git_bash_prompt_section) \e[m\e[1;34m\n\$ '
#PS1='\[\033[0;32;1;40m\]\u@\h\[\033[01;34m\] \w\[\033[0;32;1;40m\] $(git_bash_prompt_section)\[\033[01;34;0;0m\]\n\$ '

# Have bash set the output color to "normal color" after you enter a command into the
# prompt. That way your prompt coloring won't color the output of the command until its overwritten.
trap "echo -n \"$(tput sgr0)\"" DEBUG

# TODO would like to move to riley_utils eventually (see rv ssh-connect idea in the riley_utils README.md)
# for ssh-ing into audrey's personal server where we host audreyflix
alias sshaudreyflix="ssh -t riley@www.audreyflix.com \"bash\""

# for compiling C++ with warnings and errors and so on
function compilecpp() {
    g++ -Wall -Wextra -Werror -o $1.out $1.cpp
}
export -f compilecpp
