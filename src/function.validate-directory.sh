#!/usr/bin/env bash

validate_directory() {
    if [[ ! -e "${1}" ]];then
        error "The given directory '${1}' does not exist" "${EX_DIRECTORY_NOT_EXISTS}"
    elif [[ ! -d "${1}" ]];then
        error "The given directory '${1}' is not a directory" "${EX_NOT_A_DIRECTORY}"
    fi
}

# EOF
