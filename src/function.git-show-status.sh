#!/usr/bin/env bash

# Inherit the parent's verbosity if it is present
# shellcheck disable=SC2154
: export "${g_bVerbose:=false}"

git-show-status() {

    local sGitStatus sStatus sUnpushed

    readonly sGitStatus=$(git status 2> /dev/null)
    readonly sUnpushed=$(git log --branches --not --remotes)

    sStatus=''

    # --------------------------------------------------------------------------
    # Check for unpushed commits
    # --------------------------------------------------------------------------
    if [[ "${sUnpushed}" != '' ]];then
        sStatus="${sStatus}${COLOR_YELLOW}unpushed commits${COLOR_WHITE}/"
    fi

    # --------------------------------------------------------------------------
    # Check if branch is up-to-date
    # --------------------------------------------------------------------------
    if [[ ${g_bVerbose} = true ]];then
        # @NOTE: As the wording has been changes (in v2.15.0) both formats need to be checked
        if [[ -z "${sGitStatus##*Your branch is up-to-date with*}" || -z "${sGitStatus##*Your branch is up to date with*}" ]] ;then
            sStatus="${sStatus}${COLOR_GREEN}up to date${COLOR_WHITE}/"
        else
            sStatus="${sStatus}${COLOR_YELLOW}incoming changes${COLOR_WHITE}/"
        fi
    fi

    # --------------------------------------------------------------------------
    # Check for changes in the working directory
    # --------------------------------------------------------------------------
    if [[ -z "${sGitStatus##*working directory clean*}" || -z "${sGitStatus##*working tree clean*}" ]];then
        sStatus="${sStatus}${COLOR_GREEN}clean${COLOR_WHITE}/"
    else
        if [[ ${g_bVerbose} = true ]];then
            if [ -z "${sGitStatus##*Changes not staged for commit:*}" ] ;then
                sStatus="${sStatus}${COLOR_YELLOW}unstaged changes${COLOR_WHITE}/"
            fi

            if [ -z "${sGitStatus##*Changes to be committed:*}" ] ;then
                sStatus="${sStatus}${COLOR_YELLOW}staged changes${COLOR_WHITE}/"
            fi

            if [ -z "${sGitStatus##*Untracked files:*}" ] ;then
                sStatus="${sStatus}${COLOR_YELLOW}untracked files${COLOR_WHITE}/"
            fi
        else
            sStatus="${sStatus}${COLOR_YELLOW}not clean${COLOR_WHITE}/"
        fi
    fi

    # --------------------------------------------------------------------------
    # Format status string
    # --------------------------------------------------------------------------
    if [[ "${sStatus}" != '' ]];then
        # Remove trailing slash `/`
        sStatus="${sStatus: : -1}"

        sStatus="${TEXT_DIM}${COLOR_WHITE}(${sStatus}${COLOR_WHITE})${RESET_TEXT}"
    fi

    # --------------------------------------------------------------------------
    # Output
    # --------------------------------------------------------------------------
    echo "${sStatus}"
}
