#!/usr/bin/env bash
[[ -z "$AR_DIR" ]] && echo "Please set AR_DIR in your environment" && exit 0; source $AR_DIR/constants.sh
ar_os
AR_MODULE="remote-viewer"

if [ "$AR_OS" == "darwin_macos" ]; then
    # Symlink the app into /Applications/ if it doesn't exist
    [ ! -e /Applications/remote-viewer.app ] \
        && log info "Installing remote-viewer launcher scriptlet" \
        && ln -s "$AR_DIR/systems/personal/$AR_MODULE/remote-viewer.app" /Applications/
fi