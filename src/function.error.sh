#!/usr/bin/env bash

error() {
    echo "${COLOR_RED}ERROR${COLOR_RESET} ${1}" >&2
    exit "${2}"
}

# EOF
