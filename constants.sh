#!/bin/bash
# Constants/Environment variables that could exist
# Reminder: Update netinstall.sh
# ------------------:----------------------------------------------
# AR_TTY            : TTY to output silenced commands
# AR_DIR            : Base-directory for all adryd-dotfiles files
# AR_OS_TMPDIR      : OS temp folder
# AR_TMP            : adryd-dotfiles temp folder
# AR_TESTING        : whether or not to run things in debug mode
# AR_SPLASH         : whether or not the splash has shown
# ------------------:----------------------------------------------

for AR_OS_TMPDIR in "$TMPDIR" "$TMP" "$TEMP" /tmp
do
  test -n "$AR_OS_TMPDIR" && break
done

export AR_OS_TMPDIR=$AR_OS_TMPDIR
export AR_TMP="$AR_OS_TMPDIR/adryd-dotfiles/"

[[ ! $AR_TTY ]] && export AR_TTY=/dev/null
[[ ! $AR_DIR ]] && export AR_DIR="$HOME/.adryd"

[[ $AR_TESTING == true ]] \
    && export AR_TTY=$(tty) \
    && export AR_DIR="$HOME/.adryd-testing"
