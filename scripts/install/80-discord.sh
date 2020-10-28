#!/bin/bash
source $AR_DOTFILES_DIR/lib/logger.sh
# needs curl, tar, gz, sed, home folder

arDiscordBranches=("stable" "ptb" "canary" "development")
arDiscordDownloadEndpoint="https://discord.com/api/download"
arDiscordDownloadOptions="?platform=linux&format=tar.gz"
arDiscordLocalShareDir="/home/$USER/.local/share"
arDiscordTempDir="$AR_TEMP_DIR/discord"

# Make temp folder
log 0 discord "Making work folder."
mkdir -p $arDiscordTempDir/
log 0 discord "Cleaning work folder."
rm -rf $arDiscordTempDir/**

# Sanity check, this shouldn't have to happen
if [[ ! -e $arDiscordLocalShareDir ]]; then
    log 3 "Making user programs folder."
    mkdir -p $arDiscordLocalShareDir
fi

for arDiscordBranch in "${arDiscordBranches[@]}"; do

    # Discord Naming Schemes
    if [[ $arDiscordBranch = "stable" ]]; then
        arDiscordDownloadURL="$arDiscordDownloadEndpoint$arDiscordDownloadOptions"
        arDiscordName="Discord"
        arDiscordNameLowercase="discord"
    elif [[ $arDiscordBranch = "ptb" ]]; then
        arDiscordDownloadURL="$arDiscordDownloadEndpoint/$arDiscordBranch$arDiscordDownloadOptions"
        arDiscordName="Discord${arDiscordBranch^^}"
        arDiscordNameLowercase="discord-$arDiscordBranch"
    else
        arDiscordDownloadURL="$arDiscordDownloadEndpoint/$arDiscordBranch$arDiscordDownloadOptions"
        arDiscordName="Discord${arDiscordBranch^}"
        arDiscordNameLowercase="discord-$arDiscordBranch"
    fi

    log 3 discord "Downloading $arDiscordBranch."
    curl -fsSL $arDiscordDownloadURL -o $arDiscordTempDir/$arDiscordName.tar.gz

    # Overwrite existing installs
    if [[ -e $arDiscordLocalShareDir/$arDiscordName ]]; then
        log 3 discord "Deleting existing $arDiscordBranch install."
        rm -rf $arDiscordLocalShareDir/$arDiscordName
    fi

    # Extract to $arDiscordLocalShareDir
    log 3 discord "Extracting $arDiscordBranch."
    tar -xf $arDiscordTempDir/$arDiscordName.tar.gz -C $arDiscordLocalShareDir

    log 3 discord "Installing."
    # If no local icon folder exists, make one
    if [[ ! -e $arDiscordLocalShareDir/icons/hicolor/256x256 ]]; then
        log 1 discord "Making icon folder."
        mkdir -p $arDiscordLocalShareDir/icons/hicolor/256x256
    fi

    # Check to make sure no existing icons exist
    if [[ -e $arDiscordLocalShareDir/icons/hicolor/256x256/$arDiscordNameLowercase.png ]]; then
        log 1 discord "Deleting existing $arDiscordBranch icon."
        rm -rf $arDiscordLocalShareDir/icons/hicolor/256x256/$arDiscordNameLowercase.png
    fi

    log 1 discord "Linking $arDiscordBranch icon."
    ln -s $arDiscordLocalShareDir/$arDiscordName/discord.png $arDiscordLocalShareDir/icons/hicolor/256x256/$arDiscordNameLowercase.png
    
    # Fix executable location, StartupWMClass and icon
    log 1 discord "Fixing $arDiscordBranch desktop file."
    sed -i "s/Exec=\/usr\/share\/$arDiscordNameLowercase\/$arDiscordName/Exec=\"\/home\/$USER\/.local\/share\/$arDiscordName\/$arDiscordName\"/" \
        $arDiscordLocalShareDir/$arDiscordName/$arDiscordNameLowercase.desktop
    sed -i "s/StartupWMClass=discord/StartupWMClass=$arDiscordName/" \
        $arDiscordLocalShareDir/$arDiscordName/$arDiscordNameLowercase.desktop
    sed -i "s/Icon=$arDiscordNameLowercase/Icon=\/home\/$USER\/.local\/share\/icons\/hicolor\/256x256\/$arDiscordNameLowercase.png/" \
        $arDiscordLocalShareDir/$arDiscordName/$arDiscordNameLowercase.desktop
    
    # Delete existing .desktop files
    if [[ -e $arDiscordLocalShareDir/applications/$arDiscordNameLowercase.desktop ]]; then
        log 1 discord "Deleting existing $arDiscordBranch desktop file."
        rm -rf $arDiscordLocalShareDir/applications/$arDiscordNameLowercase.desktop
    fi

    # Symlink new .desktop files
    log 1 discord "Copying $arDiscordBranch desktop file."
    cp $arDiscordLocalShareDir/$arDiscordName/$arDiscordNameLowercase.desktop $arDiscordLocalShareDir/applications/$arDiscordNameLowercase.desktop

    # Run discord postinst script
    # it errors cause of bad code :)
    log 3 discord "Running Discord's postinstall script for $arDiscordBranch."
    $arDiscordLocalShareDir/$arDiscordName/postinst.sh &> /dev/null
done
        