    #!/bin/bash
    source $HOME/.adryd/constants.sh
    source $AR_DIR/lib/os.sh
    AR_MODULE="vscode"

    # for now only works on linux and with the code-oss package
    # don't use macos rn so not tempted to make it work with macos
    if [ "$AR_OS" == "linux_archlinux" ] && pacman -Q code &> /dev/null; then
        [ ! -e "$HOME/.config/Code" ] \
            && mkdir -p "$HOME/.config/Code/User" \
            && log verb "Creating vscode config folder"
        [ ! -e "$HOME/.vscode" ] \
            && mkdir -p "$HOME/.vscode" \
            && log verb "Creating vscode data folder"
        if [ ! -e "$HOME/.config/Code/User/settings.json" ]; then
            ln -sf "$AR_DIR/systems/personal/500-vscode/settings.json" "$HOME/.config/Code/User/settings.json" \
                && log info "Installing config"
        fi
    fi
