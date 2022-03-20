#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/os.sh
source ../../lib/realpath.sh
source ../../lib/log.sh
AR_MODULE="vscode"

# Set dataDir
dataDir="${HOME}/.config/Code"
[[ "$(getDistro)" = "macos" ]] && dataDir="${HOME}/Library/Application Support/Code"

# Create vscode data folder if it doesnt exist (seems to be used mostly for chromium crap)
if [[ ! -f "${dataDir}" ]]; then
    log verb "Creating vscode data folder"
    mkdir -p "${dataDir}/User"
fi

# Create vscode config folder if it doesnt exist (seems to be used for extensions)
if [[ ! -f "${HOME}/.vscode" ]]; then
    log verb "Creating vscode config folder"
    mkdir -p "${HOME}/.vscode"
fi

# If we don't already have settings
if [[ ! -f "${dataDir}/User/settings.json" ]]; then
    # Symlink settings to this repo
    log info "Installing config"
    ln -sf "$(realpath ./settings.json)" "${dataDir}/User/settings.json"
fi

source ./extension-list.sh

# For each extension
for extension in "${extensions[@]}"; do
    # Install it
    log info "Installing ${extension}"
    code --install-extension "${extension}" &> /dev/null
done
