#!/usr/bin/env bash

git_show_branch() {

    validate_directory "${1}"

    local -r sDirectory=""$(unset CDPATH && cd $1/ && pwd -P )""
    local -r sRootRepoHead="${2:-}"

    pushd "${sDirectory}" > /dev/null

    sRepo=$(basename "${sDirectory}")
    sRepoHead="$(git rev-list --parents HEAD 2> /dev/null | tail -1 || echo '')"

    if [[ "${sRootRepoHead}" = "${sRepoHead}" || "${sRepoHead}" = "" ]];then
        sBranch="${COLOR_DIM}(not a git repo)${COLOR_RESET}"
    else
        sBranch=$(git symbolic-ref --quiet --short -q HEAD 2>/dev/null)

        if [[ "${sBranch}" = 'master' ]];then
            sBranch="${COLOR_GREEN}${sBranch}${COLOR_RESET}"
        else
            sBranch="${COLOR_YELLOW}${sBranch}${COLOR_RESET}"
        fi
    fi

    popd > /dev/null

    printf '%-24s: %s\n' "${sRepo}" "${sBranch}"

    return ${EX_OK}
}

# EOF
