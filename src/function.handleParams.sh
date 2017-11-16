#!/usr/bin/env bash

# shellcheck disable=SC2154
: declare "${g_bVerbose:=false}"
# shellcheck disable=SC2154
: declare -a "${g_aParams:=}"

handleParams() {

    while [[ "$#" -ne 0 ]]; do
        case "$1" in
            #@TODO: -h|--help)
            # @TODO: --no-color)

            -v|--verbose)
                export g_bVerbose=true
            ;;

            *)
                # Regular parameter
                g_aParams+=("$1")
            ;;
        esac
        shift
    done
}
