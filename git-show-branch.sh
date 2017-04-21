#!/usr/bin/env bash

set -o errexit  # Exit script when a command exits with non-zero status.
set -o errtrace # Exit on error inside any functions or sub-shells.
set -o nounset  # Exit script on use of an undefined variable.
set -o pipefail # Return exit status of the last command in the pipe that exited with a non-zero exit code

if [[ -z ${g_sSourceDirectory-} ]];then
    readonly g_sSourceDirectory="$(dirname $(readlink ${BASH_SOURCE[0]}))"
fi

source "${g_sSourceDirectory}/color.inc"
source "${g_sSourceDirectory}/error.inc"
source "${g_sSourceDirectory}/exit-codes.inc"
source "${g_sSourceDirectory}/validate-directory.inc"

declare g_iExitCode="${EX_OK}"

git_show_branch() {

    validate_directory "${1}"

    local -r sDirectory=$(readlink -f "${1}")
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


if [[ ${BASH_SOURCE[0]} != $0 ]]; then
    export -f git_show_branch
else
    git_show_branch "${@}"
    exit ${?}
fi

# EOF
