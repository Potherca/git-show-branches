#!/usr/bin/env bash

# Inherit the parent's verbosity if it is present
# shellcheck disable=SC2154
: export "${g_bVerbose:=false}"

git-show-status() {

    local sGitStatus sStatus sUnpushed

    readonly sGitStatus=$(git status 2> /dev/null)
    readonly sUnpushed=$(git log --branches --not --remotes --decorate)

    sStatus=''

    if [[ "${sUnpushed}" != '' ]];then
        sStatus="${sStatus}${COLOR_YELLOW}unpushed commits${COLOR_WHITE}/"
    fi

    if [[ ${g_bVerbose} = true ]];then
        if [[ -z "${sGitStatus##*Your branch is up-to-date with*}" ]] ;then
            sStatus="${sStatus}${COLOR_GREEN}up-to-date${COLOR_WHITE}/"
        else
            sStatus="${sStatus}${COLOR_YELLOW}incoming changes${COLOR_WHITE}/"
        fi
    fi

    if [[ -z "${sGitStatus##*working directory clean*}" && ${g_bVerbose} = true ]] ;then
        sStatus="${sStatus}${COLOR_GREEN}clean${COLOR_WHITE}/"
    fi

    if [[ ! -z "${sGitStatus##*working directory clean*}" && ${g_bVerbose} = false ]];then
        sStatus="${sStatus}${COLOR_YELLOW}not clean${COLOR_WHITE}/"
    fi

    if [[ ! -z "${sGitStatus##*working directory clean*}" && ${g_bVerbose} = true ]];then

        if [ -z "${sGitStatus##*Changes not staged for commit:*}" ] ;then
            sStatus="${sStatus}${COLOR_YELLOW}unstaged changes${COLOR_WHITE}/"
        fi

        if [ -z "${sGitStatus##*Changes to be committed:*}" ] ;then
            sStatus="${sStatus}${COLOR_YELLOW}staged changes${COLOR_WHITE}/"
        fi

        if [ -z "${sGitStatus##*Untracked files:*}" ] ;then
            sStatus="${sStatus}${COLOR_YELLOW}untracked files${COLOR_WHITE}/"
        fi
    fi

    if [[ "${sStatus}" != '' ]];then
        # Remove trailing slash `/`
        sStatus="${sStatus: : -1}"

        sStatus="${TEXT_DIM}${COLOR_WHITE}(${sStatus}${COLOR_WHITE})${RESET_TEXT}"
    fi

    echo "${sStatus}"

}
