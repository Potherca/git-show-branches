#!/usr/bin/env bash

error() {
    echo "${COLOR_RED}ERROR${RESET_TEXT} ${1}" >&2
    exit "${2}"
}

# EOF
