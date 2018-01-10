#!/usr/bin/env bash

validate_directory() {
    if [[ ! -e "${1}" ]];then
        error "The given directory '${1}' does not exist" "${EXIT_COULD_NOT_FIND_DIRECTORY}"
    elif [[ ! -d "${1}" ]];then
        error "The given directory '${1}' is not a directory" "${EXIT_COULD_NOT_FIND_DIRECTORY}"
    fi
}

# EOF
