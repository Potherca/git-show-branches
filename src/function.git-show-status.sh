#!/usr/bin/env bash

# --------------------------------------------------------------------------
# Inherit the parent's settings if present
# --------------------------------------------------------------------------
# shellcheck disable=SC2154
: export "${g_bVerbose:=false}"

git-show-status() {

    local -a aStatus=( )
    local sGitStatus sStatus sUnpushed

    readonly sGitStatus=$(git status 2> /dev/null)
    readonly sUnpushed=$(git log --branches --not --remotes)

    sStatus=''

    # --------------------------------------------------------------------------
    # Check for unpushed commits
    # --------------------------------------------------------------------------
    if [[ $(git log --branches --not --remotes) != '' ]];then
        aStatus+=('unpushed commits')
    fi

    # --------------------------------------------------------------------------
    # Check if branch is up-to-date
    # --------------------------------------------------------------------------
    # @NOTE: As the wording has been changes (in v2.15.0) both formats need to be checked
    if [[ ! -z "${sGitStatus##*Your branch is up-to-date with*}" && ! -z "${sGitStatus##*Your branch is up to date with*}" ]] ;then
        aStatus+=('incoming changes')
    fi

    # --------------------------------------------------------------------------
    # Check for unstaged changes in the working directory
    # --------------------------------------------------------------------------
    if [[ -z "${sGitStatus##*Changes not staged for commit:*}" ]];then
        aStatus+=('unstaged changes')
    fi

    # --------------------------------------------------------------------------
    # Check for staged changes in the working directory
    # --------------------------------------------------------------------------
    if [[ -z "${sGitStatus##*Changes to be committed:*}" ]];then
        aStatus+=('staged changes')
    fi

    # --------------------------------------------------------------------------
    # Check for untracked files in the working directory
    # --------------------------------------------------------------------------
    if [[ -z "${sGitStatus##*Untracked files:*}" ]];then
        aStatus+=('untracked files')
    fi

    # --------------------------------------------------------------------------
    # Build status string
    # --------------------------------------------------------------------------
    if [[ ${g_bVerbose} = true ]];then
        if [[ "${aStatus[@]:-}" != *'incoming changes'* ]];then
            sStatus="${sStatus}${COLOR_GREEN}up to date${COLOR_WHITE}/"
        fi
    fi

    if [[ ${#aStatus[@]} = 0 ]];then
        sStatus="${sStatus}${COLOR_GREEN}clean${COLOR_WHITE}/"
    else
        if [[ ${g_bVerbose} = true ]];then
            sStatus="${sStatus}$(printf "${COLOR_YELLOW}%s${COLOR_WHITE}/" "${aStatus[@]:-}")"
        else
            sStatus="${sStatus}${COLOR_YELLOW}not clean${COLOR_WHITE}/"
        fi
    fi

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
