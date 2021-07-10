#!/bin/bash
# .adryd v5.1
# bash -c "`curl -L adryd.co/install.sh`"
# bash -c "`wget -o- adryd.co/install.sh`"

[[ -z "$AR_REMOTE_HTTPS_TAR" ]] && AR_REMOTE_HTTPS_TAR="https://gitlab.com/adryd/dotfiles/-/archive/master/dotfiles-master.tar"
[[ -z "$AR_REMOTE_GIT_HTTPS" ]] && AR_REMOTE_GIT_HTTPS="https://gitlab.com/adryd/dotfiles.git"
[[ -z "$AR_REMOTE_GIT_SSH" ]] && AR_REMOTE_GIT_SSH="git@gitlab.com:adryd/dotfiles.git"
[[ -z "$AR_DIR" ]] && AR_DIR="$HOME/.adryd"

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

function extract() {
    if [[ -x "$(command -v tar)" ]]; then
        log info "Extracting dotfiles bundle (tar)"
        tar -xf "$1" -C $AR_TMP/
        cp -r $AR_TMP/dotfiles-master "$AR_DIR"
        [[ -d "$AR_DIR" ]] && return
        log error "Failed extract with tar"
    fi
}

function download() {
    # If we have git
    # TODO: Check if we don't actually have command-line tools
    if [[ -x "$(command -v git)" ]]; then
        if [[ -f "$HOME/.ssh/id_ed25519" ]] || [[ -f "$HOME/.ssh/id_rsa" ]]; then
            log info "Cloning dotfiles repo (git+ssh)"
            git clone "$AR_REMOTE_GIT_SSH" "$AR_DIR" -qq
            [[ -d "$AR_DIR" ]] && return
            log warn "Failed cloning dotfiles repo (git+ssh)"
        fi
        # fall through to https
        log info "Cloning dotfiles repo (git+https)"
        git clone "$AR_REMOTE_GIT_HTTPS" "$AR_DIR" -qq
        [[ -d "$AR_DIR" ]] && return
        log warn "Failed cloning dotfiles repo (git+https)"
    fi

    if [[ -x "$(command -v curl)" ]]; then
        log info "Downloading dotfiles bundle (curl)"
        curl -sSo "$AR_TMP/dotfiles-master.tar" "$AR_REMOTE_HTTPS_TAR"
        [[ -f "$AR_TMP/dotfiles-master.tar" ]] && extract "$AR_TMP/dotfiles-master.tar" && return
        log warn "Failed to download (curl)"
    fi

    if [[ -x "$(command -v wget)" ]]; then
        log info "Downloading dotfiles bundle (wget)"
        wget -qO "$AR_TMP/dotfiles-master.tar" "$AR_REMOTE_HTTPS_TAR"
        [[ -f "$AR_TMP/dotfiles-master.tar" ]] && extract "$AR_TMP/dotfiles-master.tar" && return
        log warn "Failed to download (wget)"
    fi
    
    log error "All download options failed"
}

if [[ -e "$AR_DIR" ]]; then
    log error "$AR_DIR already exists. Please remove it to proceed with the installation."
    exit 1
fi

download || exit 1
log info "Downloaded to $AR_DIR"
sleep 1
$AR_DIR/install.sh
