#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="vscode"

# Try being platform agnostinc
# this is untested so be careful or your system might explode!!!
if [ "${AR_OS}" = "darwin_macos" ] || [ "${AR_OS}" = "linux_arch" ]; then

    source "${AR_DIR}/systems/personal/${AR_MODULE}/extension-list.sh"

    # Set dataDir
    [ "${AR_OS}" = "linux_arch" ] && dataDir="${HOME}/.config/Code"
    [ "${AR_OS}" = "darwin_macos" ] && dataDir="${HOME}/Library/Application Support/Code"

    # Create vscode data folder if it doesnt exist (seems to be used mostly for chromium crap)
    [ ! -e "${dataDir}" ] \
        && log verb "Creating vscode data folder" \
        && mkdir -p "${dataDir}/User"

    # Create vscode config folder if it doesnt exist (seems to be used for extensions)
    [ ! -e "${HOME}/.vscode" ] \
        && log verb "Creating vscode config folder" \
        && mkdir -p "${HOME}/.vscode"

    # If we don't already have settings
    if [ ! -e "${dataDir}/User/settings.json" ]; then
        # Symlink settings to this repo
        log info "Installing config"
        ln -sf "${AR_DIR}/systems/personal/${AR_MODULE}/settings.json" "${dataDir}/User/settings.json"
    fi

    # For each extension
    for extension in "${extensions[@]}"; do
        # Install it
        log info "Installing ${extension}"
        code --install-extension "${extension}" &> /dev/null
    done
fi
