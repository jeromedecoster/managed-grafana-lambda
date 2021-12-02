#!/bin/bash

#
# variables
#

# AWS variables
AWS_PROFILE=default
AWS_REGION=eu-west-3
# project name
PROJECT_NAME=cdktf-lambda-dynamodb
# the directory containing the script file
PROJECT_DIR="$(cd "$(dirname "$0")"; pwd)"

export AWS_PROFILE AWS_REGION PROJECT_NAME PROJECT_DIR


log()   { echo -e "\e[30;47m ${1^^} \e[0m ${@:2}"; }        # $1 uppercase background white
info()  { echo -e "\e[48;5;28m ${1^^} \e[0m ${@:2}"; }      # $1 uppercase background green
warn()  { echo -e "\e[48;5;202m ${1^^} \e[0m ${@:2}" >&2; } # $1 uppercase background orange
error() { echo -e "\e[48;5;196m ${1^^} \e[0m ${@:2}" >&2; } # $1 uppercase background red

# https://unix.stackexchange.com/a/22867
export -f log info warn error

# log $1 in underline then $@ then a newline
under() {
    local arg=$1
    shift
    echo -e "\033[0;4m${arg}\033[0m ${@}"
    echo
}

usage() {
    under usage 'call the Makefile directly: make dev
      or invoke this file directly: ./make.sh dev'
}

setup() {
    bash scripts/setup.sh
}

validate() {
    bash scripts/validate.sh
}

apply() {
    bash scripts/apply.sh
}

curl-get() {
    bash scripts/curl-get.sh
}

curl-rand-success() {
    bash scripts/curl-rand-success.sh
}

curl-error() {
    bash scripts/curl-error.sh
}

destroy() {
    bash scripts/destroy.sh
}

# if `$1` is a function, execute it. Otherwise, print usage
# compgen -A 'function' list all declared functions
# https://stackoverflow.com/a/2627461
FUNC=$(compgen -A 'function' | grep $1)
[[ -n $FUNC ]] && { info execute $1; eval $1; } || usage;
exit 0
