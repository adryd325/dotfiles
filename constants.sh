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
# AR_NODE           : path to node executable
# AR_RESOURCES      : resources url (ssl cert, ssh pubkey)
# ------------------:----------------------------------------------

for AR_OS_TMPDIR in "$TMPDIR" "$TMP" "$TEMP" /tmp
do
  test -n "$AR_OS_TMPDIR" && break
done

export AR_TMP="$AR_OS_TMPDIR/adryd-dotfiles"
export AR_SECRET="$HOME/.adryd-secret"
export AR_LOGLEVEL=3

[[ ! $AR_TTY ]] && export AR_TTY=/dev/null
[[ ! $AR_DIR ]] && export AR_DIR="$HOME/.adryd"

[[ $AR_TESTING == true ]] \
    && export AR_TTY=$(tty) \
    && export AR_DIR="$HOME/.adryd-testing" \
    && export AR_LOGLEVEL=0

export AR_RESOURCES='https://adryd.co'
