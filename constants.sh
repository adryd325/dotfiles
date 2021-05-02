#!/bin/bash
# This file is loaded at the start of every script
# Keep it minimal

[ ! $AR_SPLASH ] \
    && echo -en "\n \x1b[30;44m \x1b[0m .adryd\n \x1b[30;44m \x1b[0m version 5\n\n" \
    && export AR_SPLASH=1

# Logs
function log() {
    # Default echo args
    local logEchoArgs="-e"
    local logString=""
    local logLevel=0
    
    # Get things set up for each log level
    case $1 in
        silly)
            logLevel=0
            logString+="\x1b[30;47msill\x1b[0m "
            ;;
        verb)
            logLevel=1
            logString+="\x1b[34;40mverb\x1b[0m "
            ;;
        info)
            logLevel=2
            logString+="\x1b[36minfo\x1b[0m "
            ;;
        warn)
            logLevel=3
            logString+="\x1b[30;43mWARN\x1b[0m "
            ;;
        error)
            logLevel=4
            logString+="\x1b[31;40mERR!\x1b[0m "
            ;;
        tell)
            logLevel=5
            logString+="\x1b[32mtell\x1b[0m "
            ;;
        ask)
            logLevel=5
            logString+="\x1b[32mask:\x1b[0m "
            logEchoArgs="-en"
            ;;
    esac
    
    # If $AR_MODULE is set, prefix the log message
    [ "$AR_MODULE" ] \
        && logString+="\x1b[35m$AR_MODULE\x1b[0m "
    [ "$AR_LOG_PREFIX" != "" ] \
        && logString+="\x1b[32m($AR_LOG_PREFIX)\x1b[0m "
    # Add the rest of the arguments (merged together) to $logString
    logString+="${*:2}"
    
    # Don't print log if it's below our log level, and make sure to always show "ask" and "tell" log levels
    [ "$AR_LOGLEVEL" ] && [[ $logLevel -gt $AR_LOGLEVEL ]] && [[ $logLevel -lt 5 ]] \
        && return
    
    echo $logEchoArgs "$logString"
}

# AR_DIR
function ar_dir() {
    local manifest="adryd-dotfiles-v5"
    local defaultDir=".adryd"

    # Check if we're not installed. This variable is set before this script is loaded in download.sh
    # in this case we're setting the install target
    [[ $AR_NOT_INSTALLED -eq 1 ]] \
        && export AR_DIR="$HOME/$defaultDir"

    if [ ! "$AR_DIR" ]; then
        # First we're checking if we're somewhere in a subdirectory of .adryd
        # I'm comfortable with using $PWD cause it seems to be a bash builtin
        # I'm sure there's a better way of doing this, but oh well
        local oldPwd=$PWD
        while [ $PWD != '/' ]; do
            [ -e "$PWD/.manifest" ] \
                && [ "$(cat $PWD/.manifest)" == "$manifest" ] \
                && export AR_DIR=$PWD \
                && break
            cd ..
        done
        cd $oldPwd

        # Check the default directory
        [ -e "$HOME/$defaultDir/.manifest" ] \
            && [ "$(cat $HOME/$defaultDir/.manifest)" == "$manifest" ] \
            && export AR_DIR="$HOME/$defaultDir"

        # Give up.
        [ ! "$AR_DIR" ] \
            && log error "Could not find AR_DIR, please set it manually" \
            && exit 1
    fi
}
ar_dir