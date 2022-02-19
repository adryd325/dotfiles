#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "$AR_DIR"/constants.sh
ar_os
ar_tmp
AR_MODULE="heckheating"

function patchBranch() {
    branch=$1
    AR_LOG_PREFIX="$branch"
    # fix variables for each branch
    source "$AR_DIR/systems/personal/discord/discord-vars.sh"
    log info "Patching discord"
    if [ "$AR_OS" == "darwin_macos" ]; then
        node "$hhDir/bin/cli.js" "/Applications/$discordNameSpace.app/Contents/MacOS/$discordNameSpace" > /dev/null
    else
        node "$hhDir/bin/cli.js" "$HOME/.local/share/$discordName/$discordName" > /dev/null
    fi
}

# TODO: make platform agnostic
if [ "$AR_OS" == "linux_arch" ] || [ "$AR_OS" == "darwin_macos" ]; then
    hhDir="$HOME/.local/share/hh3"
    configDir="$HOME/.config/hh3"
    if [ "$AR_OS" == "darwin_macos" ]; then
        hhDir="$HOME/.hh3"
        configDir="$HOME/Library/Application Support/hh3"
    fi
    # Clone the repo if we don't have it, and if we might have keys
    [ ! -e "$hhDir" ] && [ -e "$HOME/.ssh" ] \
        && mkdir -p "$hhDir" \
        && log info "Cloning hh3" \
        && git clone git@gitlab.com:mstrodl/hh3 "$hhDir" --quiet

    if [ -d "$hhDir" ]; then
        oldPwd=$PWD
        cd "$hhDir" || return
        log info "Pulling latest changes"
        git pull --ff-only --quiet
        log info "Installing dependencies"
        pnpm install --recursive --silent
        cd "$hhDir/web" || return
        log info "Building webextension"
        node buildExtension.js &> /dev/null
        cd "$oldPwd" || return

        # Fix variables cause we'll need these
        branches=("stable" "canary")
        if [ "$HOSTNAME" == "popsicle" ]; then
            branches=("stable" "ptb" "canary" "development")
        fi

        for branch in "${branches[@]}"; do
            patchBranch "$branch" &
        done
        AR_LOG_PREFIX=""

        [ ! -e "$configDir" ] \
            && log info "Linking config folder" \
            && ln -s "$AR_DIR/systems/personal/$AR_MODULE" "$configDir"
        wait
    fi
fi