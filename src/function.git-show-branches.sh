#!/usr/bin/env bash

git_show_branches() {

    local sRootRepoHead sRepoHead sDirectory sBranch sRepo

    if [[ "$#" -lt 1 ]];then
        error 'One parameter expected' ${EX_NOT_ENOUGH_PARAMETERS}
    else
        validate_directory "${1}"

        local -r sRootDirectory="$(unset CDPATH && cd $1 && pwd -P )"

        pushd "${sRootDirectory}" > /dev/null
        readonly sRootRepoHead="$(git rev-list --parents HEAD 2> /dev/null | tail -1 || echo '')"
        popd > /dev/null

        for sDirectory in ${sRootDirectory}/*/;do
            git_show_branch "${sDirectory}" "${sRootRepoHead}"
        done
    fi

    return ${EX_OK}
}

# EOF
