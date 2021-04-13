#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="remote-viewer"

if [ "$AR_OS" == "macos" ]; then
    [ ! -e /Applications/remote-viewer.app ] \
        && log info "Installing remote-viewer launcher scriptlet" \
        && ln -s $AR_DIR/systems/personal/remote-viewer/remote-viewer.app /Applications/
fi