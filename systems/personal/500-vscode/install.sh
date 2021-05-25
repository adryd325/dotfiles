#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="vscode"

extensions=(
    "dbaeumer.vscode-eslint" "esbenp.prettier-vscode" "monokai.theme-monokai-pro-vscode" "ms-vsliveshare.vsliveshare"
)

# Try being platform agnostinc
# this is untested so be careful or your system might explode!!!
if [ "$AR_OS" == "darwin_macos" ] || [ "$AR_OS" == "linux_arch" ] && pacman -Q code &> /dev/null; then

    # Set dataDir
    [ $AR_OS = "linux_arch" ] && dataDir="$HOME/.config/Code"
    [ $AR_OS = "darwin_macos" ] && dataDir="$HOME/Library/Application Support/Code"

    # Create vscode data folder if it doesnt exist (seems to be used mostly for chromium crap)
    [ ! -e "$dataDir" ] \
        && log verb "Creating vscode data folder" \
        && mkdir -p "$dataDir/User"

    # Create vscode config folder if it doesnt exist (seems to be used for extensions)
    [ ! -e "$HOME/.vscode" ] \
        && log verb "Creating vscode config folder" \
        && mkdir -p "$HOME/.vscode"

    # If we don't already have settings
    if [ ! -e "$dataDir/User/settings.json" ]; then
        # Symlink settings to this repo
        log info "Installing config"
        ln -sf "$AR_DIR/systems/personal/500-vscode/settings.json" "$dataDir/User/settings.json"
    fi

    # For each extension
    for extension in "${extensions[@]}"; do
        # Install it
        log info "Installing $extension"
        code --install-extension "$extension" &> /dev/null
    done
fi
