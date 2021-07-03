#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="remote-viewer"

if [ "$AR_OS" == "darwin_macos" ]; then
    # Symlink the app into /Applications/ if it doesn't exist
    [ ! -e /Applications/remote-viewer.app ] \
        && log info "Installing remote-viewer launcher scriptlet" \
        && ln -s "$AR_DIR/systems/personal/$AR_MODULE/remote-viewer.app" /Applications/
fi