#!/usr/bin/env bash

# shellcheck disable=SC2154
: declare "${g_bVerbose:=false}"

git_show_branches() {

    declare g_aParams=()

    local sDirectory sRootDirectory sRootRepoHead

    handleParams "${@}"

    if [[ "${#g_aParams[@]}" -lt 1 ]];then
        error 'Missing required parameter: <directory>' "${EX_NOT_ENOUGH_PARAMETERS}"
    else

        validate_directory "${g_aParams[0]}"

        readonly sRootDirectory=$(unset CDPATH && cd "${g_aParams[0]}" && pwd -P )

        pushd "${sRootDirectory}" > /dev/null
        readonly sRootRepoHead="$(git rev-list --parents HEAD 2> /dev/null | tail -1 || echo '')"
        popd > /dev/null

        for sDirectory in ${sRootDirectory}/*/;do
            git_show_branch "${sDirectory}" "${sRootRepoHead}"
        done
    fi

    return "${EX_OK}"
}

# EOF
