#!/usr/bin/env bash

# Avoid `tput` to mess up output in debug mode (bash -x)
if [[ "$-" == *x* ]]; then
    bRestoreX=true
    set +x
fi

# ==============================================================================
# Foreground colors
# ------------------------------------------------------------------------------
: readonly "${COLOR_GREEN:=$(tput setaf 2)}"
: readonly "${COLOR_RED:=$(tput setaf 1)}"
: readonly "${COLOR_WHITE:=$(tput setaf 7)}"
: readonly "${COLOR_YELLOW:=$(tput setaf 3)}"
# ==============================================================================

# ==============================================================================
# Text attributes
# ------------------------------------------------------------------------------
: readonly "${RESET_TEXT:=$(tput sgr0)}"      # turn off all attributes
# ------------------------------------------------------------------------------
: readonly "${TEXT_DIM:=$(tput dim)}"         # turn on half-bright mode
# ==============================================================================

if [[ "${bRestoreX:=false}" == true ]]; then
    bRestoreX=false
    set -x
fi
