#!/bin/sh
export RV_UTILS_PATH=$(dirname "$(readlink -f $0)")
. $RV_UTILS_PATH/scripts/common/print_help.sh
. $RV_UTILS_PATH/scripts/common/utils.sh

if [ "$1" = '--help' ] || [ "$1" = '-h' ];
then
  print_logo
  print_help 'general'
  exit
fi

COMMAND=$1
shift

# NOTE: make sure that the command and its correponding script have the
# same index in their respective arrays, that's how we associate them.
COMMANDS=(
  # Git commands
  "new-branch"
  "branch"
  "clean-branches"
  "update-repo"
  "fast-forward"

  # Vim commands
  "vim-find"

  # Tmux commands
  "coding-start"
  "coding-end"

  # Riley Utils commands
  "config"
)

SCRIPTS=(
  # Git commands
  "create_new_clean_branch.sh"
  "change_to_branch.sh"
  "clean_up_orphaned_local_git_branches.sh"
  "update_repo.sh"
  "update_current_branch.sh"

  # Vim commands
  "open_file_in_vim_by_name_search.sh"

  # Tmux commands
  "start_tmux_coding_session.sh"
  "end_tmux_coding_session.sh"

  # Riley Utils commands
  "config_riley_utils.sh"
)

# Get the index of the param command in the COMMANDS array.
for i in "${!COMMANDS[@]}"; do
   if [[ "${COMMANDS[$i]}" = "${COMMAND}" ]]; then
       COMMAND_INDEX="${i}";
       FOUND=true
   fi
done

# Pull the script that has the same index as the param command.
SCRIPT_NAME=${SCRIPTS[COMMAND_INDEX]}


if [[ ! $FOUND ]]; then
  echo_error "Couldn't find script $COMMAND"
  print_help_section "usage-quick"
  exit 1
fi

# If the first argument is help, print help
if [ "$1" == "--help" ] || [ "$1" == '-h' ];
then
  print_help_sections $COMMAND
  exit 1
fi;


$RV_UTILS_PATH/scripts/$SCRIPT_NAME $@
