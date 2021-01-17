#!/bin/bash
# .adryd v5 (download)
# sh <(curl -fsSL https://adryd.co/install.sh)
# sh <(wget https://adryd.co/install.sh -Oq-)

[[ ! $AR_SPLASH ]] \
    && echo \
    && echo -e " \x1b[30;44m \x1b[0m .adryd" \
    && echo -e " \x1b[30;44m \x1b[0m version 5" \
    && echo \
    && export AR_SPLASH=1

export AR_TMP='/tmp/adryd-dotfiles'
[[ ! $AR_DIR ]] && export AR_DIR="$HOME/.adryd"
[[ $AR_TESTING -eq 1 ]] && export AR_DIR="$HOME/.adryd-testing"

AR_MODULE='download'

arDownloadGitHTTPS='https://github.com/adryd325/dotfiles.git'
arDownloadGitSSH='git@github.com:adryd325/dotfiles'
arDownloadHTTPS='https://codeload.github.com/adryd325/dotfiles/tar.gz/master'
arDownloadLocal='http://10.0.0.31:8080/dotfiles-testing.tar.gz'

# TODO: verify sha256 https://nodejs.org/dist/v14.15.4/SHASUMS256.txt.asc
# TODO: arm cpus

arNodeDownloadVersion='v14.15.4'
arNodeDownloadBuild="node-$arNodeDownloadVersion-linux-x64"
arNodeDownloadHTTPS="https://nodejs.org/dist/$arNodeDownloadVersion/$arNodeDownloadBuild.tar.xz"

# log stuff cause we're not in node yet
arLogModule="\x1b[35mdownload\x1b[0m"
arLogInfo='\x1b[32minfo\x1b[0m'
arLogWarn='\x1b[30;43mWARN\x1b[0m'
arLogError='\x1b[31;40mERR!\x1b[0m'

[[ $AR_TESTING ]] \
    && echo -e "$arLogWarn $arLogModule \$AR_TESTING is set to true, Some protections are disabled." \
    && echo -e "$arLogWarn $arLogModule For logging STDOUT and STDERR of quieted commands, put AR_TTY=\$(tty) in the env" \

# if we're testing, nuke the existing dotfiles
[[ -e $AR_DIR ]] && [[ $AR_TESTING ]] && rm -rf $AR_DIR

[[ -e $AR_DIR ]] \
    && echo -e "$arLogError $arLogModule $AR_DIR already exists. Please remove it to proceed with the installation." \
    && exit 1

# figure out what we'll be using to download the dotfiles bundle and node
[[ -x "$(command -v wget)" ]] && arDownloadDownloader="wget"
[[ -x "$(command -v curl)" ]] && arDownloadDownloader="curl"
# we're out of options now, not much else we can do unless I wanna go wild and write an http request in bash somehow
[[ $arDownloadDownloader == "" ]] \
    && echo -e "$arLogError $arLogModule No program was found to download files over https or clone git repositories." \
    && exit 1

# If we have git, just take the shortcut, no reason to not do it.
if [[ -x "$(command -v git)" ]] && [[ ! $AR_TESTING -eq 1 ]]; then
    arDownloadGit=$arDownloadGitHTTPS
    # SSH cloning is preferred, but only works if there are SSH keys installed
    # we can always git remote set-url afterwards
    [[ -e ~/.ssh/id_* ]] && arDownloadGit=$arDownloadGitSSH
    echo -e "$arLogInfo $arLogModule Cloning dotfiles"
    git clone $arDownloadGit $AR_DIR -q
elif [[ $AR_TESTING -eq 1 && -e ~/.adryd-devel ]]; then
    echo -e "$arLogInfo $arLogModule Copying dotfiles-devel"
    cp ~/.adryd-devel $AR_DIR -rf
else
    [[ $AR_TESTING -eq 1 ]] && arDownloadHTTPS=$arDownloadLocal # download locally if in testing mode
    arDownloadFile="$AR_TMP/dotfiles.tar.gz"
    [[ -e $arDownloadFile ]] && rm $arDownloadFile # delete existing download
    mkdir -p $AR_TMP
    
    echo -e "$arLogInfo $arLogModule Downloading dotfiles bundle"
    [[ $arDownloadDownloader == "curl" ]] && curl -sSLo $arDownloadFile $arDownloadHTTPS
    [[ $arDownloadDownloader == "wget" ]] && wget -O $arDownloadFile $arDownloadHTTPS

    echo -e "$arLogInfo $arLogModule Extracting dotfiles bundle"
    tar -xf $arDownloadFile -C $AR_TMP

    [[ -e $AR_TMP/dotfiles-master ]] && mv -f "$AR_TMP/dotfiles-master" $AR_DIR
    [[ -e $AR_TMP/dotfiles ]] && mv -f "$AR_TMP/dotfiles" $AR_DIR
    [[ -e $AR_TMP/.adryd ]] && mv -f "$AR_TMP/.adryd" $AR_DIR
    [[ -e $AR_TMP/.adryd-devel ]] && mv -f "$AR_TMP/.adryd-devel" $AR_DIR
    [[ -e $AR_TMP/.adryd-testing ]] && mv -f "$AR_TMP/.adryd-testing" $AR_DIR
fi

# bootstrap nodejs
# we want our own node version Just In Case:tm:
if [[ -e $AR_DIR ]] && [[ ! -e $AR_DIR/.node ]]; then
    arLogModule="\x1b[35mdownload node\x1b[0m"
    arNodeDownloadFile="$AR_TMP/node.tar.xz"
    mkdir -p $AR_TMP

    echo -e "$arLogInfo $arLogModule Downloading node"
    [[ $arDownloadDownloader == "curl" ]] && curl -so $arNodeDownloadFile $arNodeDownloadHTTPS
    [[ $arDownloadDownloader == "wget" ]] && wget -qO $arNodeDownloadFile $arNodeDownloadHTTPS

    echo -e "$arLogInfo $arLogModule Extracting node"
    tar -xf $arNodeDownloadFile -C $AR_TMP
    mv $AR_TMP/$arNodeDownloadBuild $AR_DIR/.node
    export AR_NODE=$AR_DIR/.node
fi 

sleep 1
cd $AR_DIR
$AR_DIR/install.sh
