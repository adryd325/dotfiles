#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/tmp.sh
source $AR_DIR/lib/os.sh
AR_MODULE="heckheating"

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

    if [ -e "$hhDir" ]; then
        oldPwd=$PWD
        cd "$hhDir"
        log info "Installing dependencies"
        pnpm install --recursive --silent
        cd "$hhDir/web"
        log info "Building webextension"
        node buildExtension.js &> /dev/null
        cd $oldPwd

        # Fix variables cause we'll need these
        branches=("stable" "canary")
        if [ "$HOSTNAME" == "popsicle" ]; then
            branches=("stable" "ptb" "canary" "development")
        fi

        for branch in "${branches[@]}"; do
            AR_LOG_PREFIX="$branch"
            # fix variables for each branch
            source $AR_DIR/systems/personal/500-discord/discord-vars.sh
            log info "Patching discord"
            if [ "$AR_OS" == "darwin_macos" ]; then
                node "$hhDir/bin/cli.js" "/Applications/$discordNameSpace.app/Contents/MacOS/$discordNameSpace" > /dev/null
            else
                node "$hhDir/bin/cli.js" "$HOME/.local/share/$discordName/$discordName" > /dev/null
            fi
        done
        AR_LOG_PREFIX=""

        [ ! -e "$configDir" ] \
            && log info "Linking config folder" \
            && ln -s "$AR_DIR/systems/personal/501-heckheating/hh3" "$configDir"
    fi
fi