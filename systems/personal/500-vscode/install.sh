    #!/bin/bash
    source $HOME/.adryd/constants.sh
    source $AR_DIR/lib/os.sh
    AR_MODULE="vscode"

    # for now only works on linux and with the code-oss package
    # don't use macos rn so not tempted to make it work with macos
    if [ "$AR_OS" == "linux_archlinux" ] && pacman -Q code &> /dev/null; then
        [ ! -e "$HOME/.config/Code" ] && mkdir -p "$HOME/.config/Code/User"
        [ ! -e "$HOME/.vscode" ] && mkdir -p "$HOME/.vscode"
        if [ ! -e "$HOME/.config/Code/User/settings.json" ]; then
            log info "Installing config"
            ln -sf "$AR_DIR/systems/personal/500-vscode/settings.json" "$HOME/.config/Code/User/settings.json"
        fi
    fi
