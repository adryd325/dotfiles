#!/usr/bin/env bash
export AR_NOT_INSTALLED=1

# --- BEGIN CONSTANTS ---
#!/usr/bin/env bash
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
# --- END CONSTANTS ---
AR_MODULE=download

# All of this should be overwritable by the user in testing modes\
[ ! "$AR_DOWNLOAD_HTTP_TAR" ] && AR_DOWNLOAD_HTTP_TAR="https://codeload.github.com/adryd325/dotfiles/tar.gz/master"
[ ! "$AR_DOWNLOAD_HTTP_ARCHIVE_TARGET" ] && AR_DOWNLOAD_HTTP_ARCHIVE_TARGET="dotfiles-master"
[ ! "$AR_DOWNLOAD_GIT_HTTP" ] && AR_DOWNLOAD_GIT_HTTP="https://github.com/adryd325/dotfiles"
[ ! "$AR_DOWNLOAD_GIT_SSH" ] && AR_DOWNLOAD_GIT_SSH="git@github.com:adryd325/dotfiles"
[ ! "$AR_DOWNLOAD_REPLACE_EXISTING" ] && AR_DOWNLOAD_REPLACE_EXISTING=0
[ ! "$AR_DOWNLOAD_DESTINATION" ] && AR_DOWNLOAD_DESTINATION=$AR_DIR

nodeVersion='v14.15.4'
# i dont care that this is x64 only im about to fucking cry okay i just want to replace things multiline without dying
nodeBuild="node-$nodeVersion-linux-x64"
nodeDownload="https://nodejs.org/dist/$nodeVersion/$nodeBuild.tar.xz"


# check if we can nuke the dotfiles
if [ -e "$AR_DOWNLOAD_DESTINATION" ]; then
    if [[ "$AR_DOWNLOAD_REPLACE_EXISTING" -eq 1 ]]; then
        rm -rf "$AR_DOWNLOAD_DESTINATION"
    else
        log error "$AR_DOWNLOAD_DESTINATION already exists. Please remove it to proceed with the installation."
        exit 1
    fi
fi

[[ -x "$(command -v wget)" ]] && downloader="wget"
[[ -x "$(command -v curl)" ]] && downloader="curl"

if [[ -x "$(command -v git)" ]] && [[ ! "$AR_DOWNLOAD_HTTP_FORCE" -eq 1 ]]; then
    gitUrl="$AR_DOWNLOAD_GIT_HTTP"
    [ -e ~/.ssh/id_* ] && gitUrl="$downloadGitSSH"
    log info "Cloning dotfiles repo"
    git clone "$gitUrl" "$AR_DOWNLOAD_DESTINATION" -q
else
    # Check if we can download over http
    [ ! "$downloader" ] \
        && log error "No programs were found to download over http or git" \
        && exit 1
    
    # Check if we'll be able to extract the downloaded tar file
    [[ ! -x "$(command -v tar)" ]] \
        && log error "No programs were found to extract tar files" \
        && exit 1
    
    # Temp file
    destinationFile="/tmp/adryd-dotfiles-dl.tar"

    log info "Downloading dotfiles bundle"
    # Download depending on which program we have
    [ "$downloader" == "curl" ] && curl -sSLo "$destinationFile" "$AR_DOWNLOAD_HTTP_TAR"
    [ "$downloader" == "wget" ] && wget -qO "$destinationFile" "$AR_DOWNLOAD_HTTP_TAR"
    
    # Make a temp folder
    mkdir /tmp/adryd-dotfiles-dl/

    log info "Extracting dotfiles bundle"
    tar -xf "$destinationFile" -C /tmp/adryd-dotfiles-dl/

    log info "Moving extracted bundle"

    # if $AR_DOWNLOAD_HTTP_ARCHIVE_TARGET is empty, it coppies the folder itself to $AR_DOWNLOAD_DESTINATION
    [ -e "/tmp/adryd-dotfiles-dl/$AR_DOWNLOAD_HTTP_ARCHIVE_TARGET" ] \
        && cp -r "/tmp/adryd-dotfiles-dl/$AR_DOWNLOAD_HTTP_ARCHIVE_TARGET" "$AR_DOWNLOAD_DESTINATION"
    rm -rf /tmp/adryd-dotfiles-dl/ "$destinationFile"
fi

# download node because i am fucking 2 and dont know how to MULTILINE REPLACE IN SHELL SCRIPT ITS TOO FUCKING SCARY AND 
# UGH KILL ME FUCKING KILL ME FUCKING KILL ME FUCKING KILL ME
if [ -e $AR_DIR ] && [ ! -e $AR_DIR/.node ]; then
    destinationFile="/tmp/adryd-dotfiles-node/node.tar.xz"
    mkdir -p /tmp/adryd-dotfiles-node

    log info "Downloading node"
    [ "$downloader" == "curl" ] && curl -sSLo "$destinationFile" "$nodeDownload"
    [ "$downloader" == "wget" ] && wget -qO "$destinationFile" "$nodeDownload"

    log info "Extracting node"
    tar -xf "$destinationFile" -C /tmp/adryd-dotfiles-node/
    mv "/tmp/adryd-dotfiles-node/$nodeBuild" "$AR_DIR/.node"
fi 

log info "Downloaded to $AR_DOWNLOAD_DESTINATION"

export AR_NOT_INSTALLED=0
sleep 1
cd $AR_DOWNLOAD_DESTINATION
$AR_DOWNLOAD_DESTINATION/startup.sh
