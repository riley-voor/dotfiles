#!/bin/sh

# This file contains common utility functions for the rest of the scripts.

function echo_command()
{
  BOLD_GREEN='\033[1;32m'
  NO_COLOR='\033[0m'

  echo "${BOLD_GREEN}$1${NO_COLOR}"
}

function echo_error()
{
  BOLD_RED='\033[1;31m'
  NO_COLOR='\033[0m'

  echo "${BOLD_RED}$1${NO_COLOR}"
}

