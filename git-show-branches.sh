#!/usr/bin/env bash

set -o errexit  # Exit script when a command exits with non-zero status.
set -o errtrace # Exit on error inside any functions or sub-shells.
set -o nounset  # Exit script on use of an undefined variable.
set -o pipefail # Return exit status of the last command in the pipe that exited with a non-zero exit code

readonly g_sSourceDirectory="$(dirname $(readlink ${BASH_SOURCE[0]}))"

source "${g_sSourceDirectory}/git-show-branch.sh"

git_show_branches() {

    local sRootRepoHead sRepoHead sDirectory sBranch sRepo

    if [[ "$#" -lt 1 ]];then
        error 'One parameter expected' ${EX_NOT_ENOUGH_PARAMETERS}
    else
        validate_directory "${1}"

        local -r sRootDirectory=$(readlink -f "${1}")

        pushd "${sRootDirectory}" > /dev/null
        readonly sRootRepoHead="$(git rev-list --parents HEAD 2> /dev/null | tail -1 || echo '')"
        popd > /dev/null

        for sDirectory in ${sRootDirectory}/*/;do
            git_show_branch "${sDirectory}" "${sRootRepoHead}"
        done
    fi

    return ${EX_OK}
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
    export -f git_show_branches
else
     git_show_branches "${@}"
    exit ${?}
fi

# EOF
