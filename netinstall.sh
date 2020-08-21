#!/bin/bash
# .adryd netinstall v4.0
# curl -fsL https://adryd.co/install.sh | bash
# wget https://adryd.co/install.sh -Oq- | bash

echo 
echo -e " \x1b[30;44m            _                _ \x1b[0m"
echo -e " \x1b[30;44m   __ _  __| |_ __ _   _  __| |\x1b[0m"
echo -e " \x1b[30;44m  / _\` |/ _\` | '__| | | |/ _\` |\x1b[0m"
echo -e " \x1b[30;44m | (_| | (_| | |  | |_| | (_| |\x1b[0m"
echo -e " \x1b[30;44m(_)__,_|\__,_|_|   \__, |\__,_|\x1b[0m"
echo -e " \x1b[30;44m        version 4.0|___/       \x1b[0m"
echo
echo -e " \x1b[30;44m \x1b[0m netinstall"
echo -e " \x1b[30;44m \x1b[0m version 4.0"
echo

# constants
AR_GIT_REPO"https://github.com/adryd325/dotfiles.git" # https in case there are no SSH keys
AR_DOWNLOAD_BASEURL="https://codeload.github.com/adryd325/dotfiles/"
AR_DOTFILES_DIR=~/.adryd

arDate="$(date +%y%m%d%H%M%S)"

function getExtract() {
    if [[ -x "$(command -v tar)" ]]; then
       arExtract="tar.gz"
    elif [[ -x "$(command -v unzip)" ]]; then
        arExtract="zip"
    else
        echo "No program was found to extract zip or tar.gz archives."
    fi
}

function getDownload() {
    if [[ -x "$(command -v curl)" ]]; then
       arDownload="curl"
    elif [[ -x "$(command -v wget)" ]]; then
        arDownload="wget"
    else
        echo "No program was found to download files with https."
    fi
}

if [[ -e $AR_DOTFILES_DIR ]]; then
    echo "$AR_DOTFILES_DIR already exists. Please remove it to proceed with the installation"
    exit 1
fi

if [[ -x "$(command -v git)" ]]; then
    git clone $AR_GIT_REPO $AR_DOTFILES_DIR
    # we done now
elif [[ -x "$(command -v curl)" ]]; then
    getDownload
    getExtract
    arDownloadUrl="$AR_DOWNLOAD_BASEURL/$arExtract/master"
    arTmpFolder="/tmp/dotadryd-$arDate"
    arDownloadedArchive="$arTmpFolder/dotfiles.$arExtract"
    mkdir $arTmpFolder
    if [[ $arDownload == "curl" ]]; then
        curl -L -o $arDownloadedArchive $arDownloadUrl
    elif [[ $arDownload == "wget" ]]; then
        wget -O $arDownloadedArchive $arDownloadUrl
    fi
    if [[ $arExtract == "tar.gz" ]]; then
        tar -xf $arDownloadedArchive -C $arTmpFolder
    elif [[ $arExtract == "zip" ]]; then
        unzip $arDownloadedArchive -d $arTmpFolder
    fi
    mv -f "$arTmpFolder/dotfiles-master" $arDotfilesDir
    rm -rf $arTmpFolder
fi

chmod +x $arDotfilesDir/install.sh
$arDotfilesDir/install.sh
