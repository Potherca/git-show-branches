#!/usr/bin/env bash

# shellcheck disable=SC2154
: declare "${g_bVerbose:=false}"

git_show_branch() {

    declare g_aParams=()

    local sBranch sDirectory sRepo sRepoHead sRootRepoHead sStatus

    git_fetch() {
        local -i iResult
        local sResult

        iResult=0

        sResult=$(git fetch -p 2>&1) || iResult=$?

        if [[ ${iResult} != 0 ]];then
            error "${sResult}" "${EX_ERROR_UPDATING}"
        fi
    }

    handleParams "${@}"

    validate_directory "${g_aParams[0]}"

    readonly sDirectory=$(unset CDPATH && cd "${g_aParams[0]}"/ && pwd -P )
    readonly sRootRepoHead="${g_aParams[1]:=}"

    pushd "${sDirectory}" > /dev/null

    readonly sRepo=$(basename "${sDirectory}")
    readonly sRepoHead="$(git rev-list --parents HEAD 2> /dev/null | tail -1 || echo '')"

    sStatus=''

    if [[ "${sRootRepoHead}" = "${sRepoHead}" || "${sRepoHead}" = "" ]];then
        readonly sBranch="${TEXT_DIM}(not a git repo)${RESET_TEXT}"
    else

        sBranch=$(git symbolic-ref --quiet --short -q HEAD 2>/dev/null)

        if [[ "${sBranch}" = 'master' ]];then
            readonly sBranch="${COLOR_GREEN}${sBranch}${RESET_TEXT}"
        else
            readonly sBranch="${COLOR_YELLOW}${sBranch}${RESET_TEXT}"
        fi

        if [[ ${g_bVerbose} = true ]];then
            git_fetch
        fi

        readonly sStatus=$(git-show-status)
    fi

    popd > /dev/null

    printf '%-24s: %s %s\n' "${sRepo}" "${sBranch}" "${sStatus}"

    return "${EX_OK}"
}

# EOF
