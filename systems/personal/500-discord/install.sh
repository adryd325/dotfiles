#!/bin/bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/tmp.sh
source $AR_DIR/lib/os.sh
AR_MODULE="discord"

# not really dependent on any distros
if [ "$AR_KERNEL" == "linux" ] && [ -e "$(command -v curl)" ]; then
    downloadEndpoint='https://discord.com/api/download'
    downloadOptions='?platform=linux&format=tar.gz'

    branches=("stable" "canary")
    if [ "$HOSTNAME" == "popsicle" ]; then
        branches=("stable" "ptb" "canary" "development")
    fi

    [ -e "$AR_TMP/discord" ] && rm -rf "$AR_TMP/discord"
    [ ! -e "$HOME/.local/share" ] && mkdir -p "$HOME/.local/share"
    mkdir -p "$AR_TMP/discord"
    workDir="$AR_TMP/discord"

    for branch in "${branches[@]}"; do
        # fix variables for each branch
        source $AR_DIR/systems/personal/500-discord/discord-vars.sh
        AR_LOG_PREFIX="$branch"
        log info "Downloading"
        mkdir -p $workDir
        curl -fsSL $downloadURL -o $workDir/$discordName.tar.gz || continue

        if [ -e "$HOME/.local/share/$discordName/$discordName" ]; then
            log info "Deleting existing install"
            rm -rf "$HOME/.local/share/$discordName/"
        fi

        log info "Extracting"
        tar -xf "$workDir/$discordName.tar.gz" -C "$HOME/.local/share" || continue

        log info "Installing"
        # If no local icon folder exists, make one
        if [ ! -e "$HOME/.local/share/icons/hicolor/256x256" ]; then
            log verb "Making icon folder"
            mkdir -p "$HOME/.local/share/icons/hicolor/256x256"
        fi

        # Check to make sure no existing icons exist
        if [ -e "$HOME/.local/share/icons/hicolor/256x256/$discordLowercase.png" ]; then
            log verb "Deleting existing icon"
            rm -rf "$HOME/.local/share/icons/hicolor/256x256/$discordLowercase.png"
        fi

        log verb "Linking icon"
        ln -s "$HOME/.local/share/$discordName/discord.png" "$HOME/.local/share/icons/hicolor/256x256/$discordLowercase.png"
        
        log verb "Patching .desktop file"
        sed -i "s/Exec=\/usr\/share\/$discordLowercase\/$discordName/Exec=\"\/home\/$USER\/.local\/share\/$discordName\/$discordName\"/" \
            $HOME/.local/share/$discordName/$discordLowercase.desktop
        sed -i "s/StartupWMClass=discord/StartupWMClass=$discordName/" \
            $HOME/.local/share/$discordName/$discordLowercase.desktop
        sed -i "s/Icon=$discordLowercase/Icon=\/home\/$USER\/.local\/share\/icons\/hicolor\/256x256\/$discordLowercase.png/" \
            $HOME/.local/share/$discordName/$discordLowercase.desktop

         # Delete existing .desktop files
        if [ -e "$HOME/.local/share/applications/$discordLowercase.desktop" ]; then
            log verb "Deleting existing .desktop file"
            rm -rf "$HOME/.local/share/applications/$discordLowercase.desktop"
        fi

        # Symlink new .desktop files
        log verb "Installing .desktop file"
        mkdir -p "$HOME/.local/share/applications"
        cp "$HOME/.local/share/$discordName/$discordLowercase.desktop" "$HOME/.local/share/applications/$discordLowercase.desktop"

        # Run discord postinst script
        # it errors cause of bad code :)
        # log verb "Running Discord's postinstall script"
        # $HOME/.local/share/$discordName/postinst.sh &> /dev/null
    done
    AR_LOG_PREFIX=""
fi