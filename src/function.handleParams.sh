#!/usr/bin/env bash

# shellcheck disable=SC2154
: declare "${g_bVerbose:=false}"
# shellcheck disable=SC2154
: declare "${g_bIgnoreUntrackedFiles:=false}"
# shellcheck disable=SC2154
: declare -a "${g_aParams:=}"

handleParams() {

    while [[ "$#" -ne 0 ]]; do

        case "$1" in
            # @TODO: -h|--help)
            # @TODO: --no-color)

            -uv|-vu)
                export g_bIgnoreUntrackedFiles=true
                export g_bVerbose=true
            ;;

            -u|--ignore-untracked-files)
                export g_bIgnoreUntrackedFiles=true
            ;;

            -v|--verbose)
                export g_bVerbose=true
            ;;

            --)
                # Divider for path parameter
                # @FIXME: Add strict enforcement so directories starting with `-` or `--` are also supported
            ;;

            -*|--*)
                iStrip=1
                if [[ "$1" =~ ^--.* ]]; then
                    iStrip=2
                fi

                error " invalid option -- '${1:${iStrip}:${#1}}'" "${EXIT_INVALID_PARAMETER}"
            ;;

            *)
                # Regular parameter
                g_aParams+=("$1")
            ;;
        esac
        shift
    done
}
