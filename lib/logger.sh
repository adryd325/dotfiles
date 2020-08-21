#!/bin/bash
# npmlog but bash!

arLogLevel=0
arLogLevelString=("\x1b[30;47msill" "\x1b[34;40mverb" "\x1b[36mprog" "\x1b[32minfo" "\x1b[30;43mWARN" "\x1b[31;40mERR!")

function log() {
    # if log level is below our current log level we dont care, just throw it out
    if [[ $1 < $arLogLevel ]]; then
        return
    fi
    arTitleString=""
    arLogString=$2
    if [[ $3 ]]; then 
        arTitleString="\x1b[35m$2\x1b[0m "
        arLogString=$3
    fi
    echo -e "${arLogLevelString[$1]}\x1b[0m $arTitleString$arLogString"
}

function sill() {
    log 0 $1 $2
}

function verb() {
    log 1 $1 $2
}

function prog() {
    log 2 $1 $2
}

function info() {
    log 3 $1 $2
}

function warn() {
    log 4 $1 $2
}

function err() {
    log 5 $1 $2
}