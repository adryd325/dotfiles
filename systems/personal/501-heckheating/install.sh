#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/tmp.sh
source $AR_DIR/lib/os.sh
AR_MODULE="heckheating"

# TODO: make platform agnostic
# .local/share == /.hh3/
# .config == /library/application support/
if [ "$AR_OS" == "linux_arch" ]; then
    # Clone the repo if we don't have it, and if we might have keys
    [ ! -e "$HOME/.local/share/hh3" ] && [ -e "$HOME/.ssh" ] \
        && mkdir -p "$HOME/.local/share" \
        && log info "Cloning hh3" \
        && git clone git@gitlab.com:mstrodl/hh3 $HOME/.local/share/hh3 --quiet

    if [ -e "$HOME/.local/share/hh3" ]; then
        oldPwd=$PWD
        cd $HOME/.local/share/hh3
        log info "Installing dependencies"
        pnpm install --recursive --silent
        cd $HOME/.local/share/hh3/web
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
            node "$HOME/.local/share/hh3/bin/cli.js" "$HOME/.local/share/$discordName/$discordName" > /dev/null
        done
        AR_LOG_PREFIX=""

        [ ! -e ~/.config/hh3 ] \
            && log info "Linking config folder" \
            && ln -s "$AR_DIR/systems/personal/501-heckheating/hh3" "$HOME/.config/hh3"
    fi
fi