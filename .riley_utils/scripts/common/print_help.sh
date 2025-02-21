. $RV_UTILS_PATH/scripts/common/utils.sh

COLORS=(
  $NO_COLOR
  $BOLD_GREEN
  $BOLD_TEAL
)

function print_help_section() {
  input="$RV_UTILS_PATH/documentation/${1}.txt"
  while IFS= read -r line
  do
    # If the line of the usage.txt file starts with a #, give it a color
    if [[ $line =~ ^\#+[[:space:]] ]]; then
      HEADLINE_LEVEL=${#BASH_REMATCH}
      COLOR_SETTER=${COLORS[HEADLINE_LEVEL - 1]}
      echo "${line//$BASH_REMATCH/$COLOR_SETTER}"
    else
      echo "${NO_COLOR}$line"
    fi
  done < "$input"

}

function print_help_sections() {

  for section in "${@:-usage-quick}"
  do
    print_help_section $section
  done

  exit
}

function print_help()
{
  if [[ "$1" == "--help" ]] || [[ "$1" == '-h' ]]; then
    print_logo
    shift
    print_help_sections $@
    exit
  fi
}
