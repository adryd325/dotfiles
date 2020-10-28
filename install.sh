#!/bin/bash
# .adryd netinstall v4.0
# curl -fsL https://adryd.co/install.sh | bash
# wget https://adryd.co/install.sh -Oq- | bash

# constants

AR_GIT_REPO='https://github.com/adryd325/dotfiles.git' # https in case there are no SSH keys
AR_GIT_SSH_REPO='git@github.com:adryd325/dotfiles' # if .ssh exists
AR_LOCALDOWNLOAD="http://popsicle.in.adryd/dotfiles.tar?$RANDOM" # dont ask
AR_DOWNLOAD_BASEURL='https://codeload.github.com/adryd325/dotfiles/'
export AR_DOTFILES_DIR=~/.adryd

arDate="$(date +%y%m%d%H%M%S)"

[[ -e $AR_DOTFILES_DIR && $PWD == $AR_DOTFILES_DIR ]] && $AR_DOTFILES_DIR/index.sh && exit

# echo 
# echo -e " \x1b[30;44m            _                _ \x1b[0m"
# echo -e " \x1b[30;44m   __ _  __| |_ __ _   _  __| |\x1b[0m"
# echo -e " \x1b[30;44m  / _\` |/ _\` | '__| | | |/ _\` |\x1b[0m"
# echo -e " \x1b[30;44m | (_| | (_| | |  | |_| | (_| |\x1b[0m"
# echo -e " \x1b[30;44m(_)__,_|\__,_|_|   \__, |\__,_|\x1b[0m"
# echo -e " \x1b[30;44m        version 4.0|___/       \x1b[0m"
echo
echo -e " \x1b[30;44m \x1b[0m .adryd netinstall"
echo -e " \x1b[30;44m \x1b[0m version 4.1"
echo

[[ -e $AR_DOTFILES_DIR ]] && echo "$AR_DOTFILES_DIR already exists. Please remove it to proceed with the installation" && exit 1

[[ -x "$(command -v wget)" ]] && arDownloader="wget"
[[ -x "$(command -v curl)" ]] && arDownloader="curl"
#[[ -x "$(command -v git)" ]] && arDownloader="git"
[[ $arDownloader == "" ]] && echo "No program was found to download files over https or clone git repositories." && exit 1

if [[ $arDownload != "git" ]]; then
    [[ -x "$(command -v unzip)" ]] && arExtractor="zip"
    [[ -x "$(command -v tar)" ]] && arExtractor="tar.gz"
    [[ $arExtractor == "" ]] && echo "No program was found to extract zip or tar.gz archives or clone git repositories." && exit 1
fi

if [[ $arDownloader == "git" && $AR_INTERNAL != true ]]; then
    arGitRepo=$AR_GIT_REPO
    [[ -e ~/.ssh ]] && arGitRepo=$AR_GIT_SSH_REPO
    echo -e '\x1b[36mprog \x1b[35mnetinstall \x1b[0mDownloading...'
    git clone $arGitRepo $AR_DOTFILES_DIR 2> /dev/null
    # we done now
else
    arDownloadUrl="$AR_DOWNLOAD_BASEURL/$arExtractor/master"
    [[ $AR_INTERNAL = true ]] && arDownloadUrl=$AR_LOCALDOWNLOAD
    arTmpFolder="/tmp/dotadryd-$arDate"
    arDownloadedArchive="$arTmpFolder/dotfiles.$arExtractor"
    mkdir $arTmpFolder
    echo -e '\x1b[36mprog \x1b[35mnetinstall \x1b[0mDownloading...'
    [[ $arDownloader == "curl" ]] && curl -sSL -o $arDownloadedArchive $arDownloadUrl 
    [[ $arDownloader == "wget" ]] && wget -q -O $arDownloadedArchive $arDownloadUrl
    echo -e '\x1b[36mprog \x1b[35mnetinstall \x1b[0mExtracting...'
    [[ $arExtractor == "tar.gz" ]] && tar -xf $arDownloadedArchive -C $arTmpFolder
    [[ $arExtractor == "zip" ]] && unzip -qq $arDownloadedArchive -d $arTmpFolder
    mv -f "$arTmpFolder/dotfiles-master" $AR_DOTFILES_DIR
    rm -rf $arTmpFolder
fi

chmod +x $AR_DOTFILES_DIR/index.sh # just in case
$AR_DOTFILES_DIR/index.sh
