#!/usr/bin/env bash
# --- BEGIN CONSTANTS --- 
function ar_dir() {
    if [ ! "$AR_DIR" ]; then
        function check() {
            if [[ -f "$1/.manifest" ]] && [[ "$(cat $1/.manifest)" = "adryd-dotfiles-v5.1" ]]; then
                cd "$oldPwd"
                export AR_DIR="$1"
                return 0
            fi
            return 1
        }
        local oldPwd=$PWD
        cd "$(dirname $0)"
        while [[ "$PWD" != '/' ]]; do check "$PWD" && return 0; cd ..; done
        cd "$oldPwd"
        while [[ "$PWD" != '/' ]]; do check "$PWD" && return 0; cd ..; done
        cd "$oldPwd"
        check "$HOME/.adryd" && return
        check "/root/.adryd" && return
        return 1
    fi
    return 0
}
ar_dir

function ar_splash() {
    if [[ -z "$AR_SPLASH" ]] && [[ "$0" = "$AR_DIR"* ]] || [[ "$AR_MODULE" = "download" ]]; then
        echo -en "\n \x1b[30;44m \x1b[0m .adryd\n \x1b[30;44m \x1b[0m version 5.1\n\n"
        export AR_SPLASH=1
    fi
}
ar_splash

function ar_os() {
    export AR_OS_KERNEL="$(uname -s | tr '[:upper:]' '[:lower:]')"
    if [[ "$AR_OS_KERNEL" = "linux" ]]; then
        # This is what neofetch does, so I feel safe doing the same
        [[ -f /etc/os-release ]] && source /etc/os-release
        export AR_OS_DISTRO="$(echo $ID | sed 's/ //g' | tr '[:upper:]' '[:lower:]')"
        export AR_OS="${AR_OS_KERNEL}_$AR_OS_DISTRO"
    fi
    if [[ "$AR_OS_KERNEL" = "darwin" ]]; then
        export AR_OS_DISTRO="macos"
        export AR_OS="${AR_OS_KERNEL}_$AR_OS_DISTRO"
    fi
}

function ar_tmp() {
    if [[ -z "$AR_TMP" ]]; then
        if [[ -x "$(command -v mktemp)" ]]; then
            export AR_TMP="$(mktemp -d -t adryd-dotfiles.XXXXXXXXXX)"
        else
            for tempDir in "$TMPDIR" "$TMP" "$TEMP" /tmp; do
                if [[ -d "$osTempDir" ]]; then
                    export AR_TMP="$osTempDir/adryd-dotfiles.$RANDOM"
                    break
                fi
            done
        fi
        if [[ -z "$AR_TMP" ]]; then
            log error "Could not find temp folder"
            exit 1
        fi
    fi
}

function log() {
    local echoArgs="-e"
    local logString=""
    local logLevel=0
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
            echoArgs="-en"
            ;;
    esac
    [[ -n "$AR_MODULE" ]] && logString+="\x1b[35m$AR_MODULE\x1b[0m "
    [[ -n "$AR_LOG_PREFIX" ]] && logString+="\x1b[32m($AR_LOG_PREFIX)\x1b[0m "
    logString+="${*:2}"
    [[ -n $AR_LOGLEVEL ]] && [[ $logLevel -lt $AR_LOGLEVEL ]] && [[ $logLevel -lt 5 ]] && return
    echo $echoArgs "$logString"
}
# --- END CONSTANTS ---

export PATH="$AR_DIR/systems/personal/bin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"

export NODE_EXTRA_CA_CERTS="$AR_DIR/systems/common/ca-certificates/adryd-root-ca.pem"

source "$AR_DIR/systems/personal/bash/aliases.sh"

unset AR_OS
unset AR_OS_DISTRO
unset AR_OS_KERNEL