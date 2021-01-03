#!/bin/bash
# .adryd v4.2 (netinstall)
# bash -c "$(curl -fsSL https://adryd.co/install.sh)"
# bash -c "$(wget https://adryd.co/install.sh -Oq-)"

[[ ! $AR_SPLASH ]] \
    && echo \
    && echo -e " \x1b[30;44m \x1b[0m .adryd" \
    && echo -e " \x1b[30;44m \x1b[0m version 4.2" \
    && echo \
    && AR_SPLASH=true

# global constants
for AR_OS_TMPDIR in "$TMPDIR" "$TMP" "$TEMP" /tmp
do
  test -n "$AR_OS_TMPDIR" && break
done

export AR_OS_TMPDIR=$AR_OS_TMPDIR
export AR_TMP="$AR_OS_TMPDIR/adryd-dotfiles"

[[ ! $AR_TTY ]] && export AR_TTY=/dev/null
[[ ! $AR_DIR ]] && export AR_DIR="$HOME/.adryd"

[[ $AR_TESTING == true ]] \
    && export AR_TTY=$(tty) \
    && export AR_DIR="$HOME/.adryd-testing"

AR_MODULE='netinstall'

# local constants
arNetinstallGitHTTP='https://github.com/adryd325/dotfiles.git'
arNetinstallGitSSH='git@github.com:adryd325/dotfiles'
arNetinstallBaseURL='https://codeload.github.com/adryd325/dotfiles/'
arNetinstallLocalDownload="https://adryd.co/dotfiles-testing.tar?$RANDOM" # easier than committing to git every time

# cause we can't import lib/logger
arLogModule="\x1b[35m$AR_MODULE\x1b[0m"
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

# figure out how to download the package
[[ -x "$(command -v wget)" ]] && arNetinstallDownloader="wget"
[[ -x "$(command -v curl)" ]] && arNetinstallDownloader="curl"
[[ -x "$(command -v git)" ]] && [[ $AR_TESTING != true ]] && arNetinstallDownloader="git"
[[ $arNetinstallDownloader == "" ]] \
    && echo -e "$arLogError $arLogModule No program was found to download files over https or clone git repositories." \
    && exit 1

# if we're downloading a zip or tar, figure out how we're going to extract the package
if [[ $arNetinstallDownloader != "git" ]]; then
    [[ -x "$(command -v unzip)" ]] && arNetinstallExtractor="zip"
    [[ -x "$(command -v tar)" ]] && arNetinstallExtractor="tar.gz"
    [[ $arNetinstallExtractor == "" ]] \
        && echo -e "$arLogError $arLogModule No program was found to extract zip or tar.gz archives or clone git repositories." \
        && exit 1
fi

if [[ $arNetinstallDownloader == "git" ]]; then
    arNetinstallGit=$arNetinstallGitHTTP
    # SSH cloning is preferred, but only works if there are SSH keys installed
    [[ -e ~/.ssh/id_* ]] && arNetinstallGit=$arNetinstallGitSSH

    echo -e "$arLogInfo $arLogModule Cloning..."
    git clone $arNetinstallGit $AR_DIR 2> $AR_TTY

else 
    arNetinstallDownloadURL="$arNetinstallBaseURL/$arNetinstallExtractor/master" # build download url
    [[ $AR_TESTING = true ]] && arNetinstallDownloadURL=$arNetinstallLocalDownload # download locally if in testing mode
    arNetinstallArchive="$AR_TMP/dotfiles.$arNetinstallExtractor" # download destination
    [[ -e $arNetinstallArchive ]] && rm $arNetinstallArchive # delete any existing downloads
    mkdir -p $AR_TMP

    echo -e "$arLogInfo $arLogModule Downloading..."
    [[ $arNetinstallDownloader == "curl" ]] && curl -Lo $arNetinstallArchive $arNetinstallDownloadURL 2> $AR_TTY
    [[ $arNetinstallDownloader == "wget" ]] && wget -O $arNetinstallArchive $arNetinstallDownloadURL 2> $AR_TTY

    echo -e "$arLogInfo $arLogModule Extracting..."
    [[ $arNetinstallDownloader == "tar.gz" ]] && tar -xvf $arNetinstallArchive -C $AR_TMP > $AR_TTY
    [[ $arNetinstallDownloader == "zip" ]] && unzip $arNetinstallArchive -d $AR_TMP > $AR_TTY
    ls $AR_TMP
    # probably a better way to do that /shrug
    [[ $AR_TESTING != true ]] && mv -f "$AR_TMP/dotfiles-master" $AR_DIR
    [[ $AR_TESTING == true ]] && mv -f "$AR_TMP/dotfiles" $AR_DIR
    rm -rf $AR_TMP
fi

sleep 1
cd $AR_DIR
$AR_DIR/install.sh