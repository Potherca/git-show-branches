#!/usr/bin/env bash

set -o errexit  # Exit script when a command exits with non-zero status.
set -o errtrace # Exit on error inside any functions or sub-shells.
set -o nounset  # Exit script on use of an undefined variable.
set -o pipefail # Return exit status of the last command in the pipe that exited with a non-zero exit code

source "color.inc"
source "exit-codes.inc"
source "function.error.sh"
source "function.handleParams.sh"
source "function.validate-directory.sh"
source 'function.git-show-branch.sh'
source 'function.git-show-branches.sh'
source 'function.git-show-status.sh'

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
    export -f git_show_branches
else
    git_show_branches "${@:-}"
    exit ${?}
fi

# EOF
