#!/bin/sh

. $RV_UTILS_PATH/scripts/common/utils.sh

print_help()
{
  input="$RV_UTILS_PATH/documentation/${1}.txt"
  while IFS= read -r line
  do
    # If the line of the .txt file starts with #, make it teal
    # If the line of the .txt file starts with ##, make it green
    if echo "${line}" | egrep -q "^\##.*$";
    then
      line_text=$(echo "$line" | sed -r 's/^## (.*)$/\1/')
      echo "${BOLD_GREEN}$line_text"
    elif echo "${line}" | egrep -q "^\#.*$";
    then
      line_text=$(echo "$line" | sed -r 's/^# (.*)$/\1/')
      echo "${BOLD_TEAL}$line_text"
    else
      echo "${NO_COLOR}$line"
    fi
  done < "$input"
}
