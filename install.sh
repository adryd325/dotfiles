#!/bin/bash

source $AR_DIR/constants.sh
source $AR_DIR/lib/log.sh
export AR_MODULE='install'

[[ ! $AR_SPLASH ]] \
    && echo \
    && echo -e " \x1b[30;44m \x1b[0m .adryd" \
    && echo -e " \x1b[30;44m \x1b[0m version 5" \
    && echo \
    && export AR_SPLASH=1

if [[ ! $1 ]]; then
    log 0 'Checking for archiso'
    if [[ $HOSTNAME == 'archiso' ]] && [[ $USER == 'root' ]]; then
        log 2 'Detected archiso. Running Arch install script'
        $AR_DIR/modules/archinstall/index.sh
        log 0 'Arch install script done, exiting'
        exit 0
    fi
    log 0 'Checking for Debian LXC'
    cat /etc/os-release | grep "ID=debian" &> /dev/null
    if [[ $? -eq 0 ]] && [[ $(systemd-detect-virt) == 'lxc' ]]; then
        if [[ $USER == 'root' ]]; then
            log 2 'Detected LXC. Running LXC setup script'
            $AR_DIR/extra/lemon/lxcs/install.sh
            log 0 'LXC install script done'
            exit 0
        else
            log 2 'Detected LXC. Please run with escalated privelages'
            exit 0
        fi
    fi
fi

# it's cursed, but this is the best way I thought of doing this without overcomplicating things
for installStage in {100..999}; do
    [[ $installStage -eq 200 ]] && log 2 'At DE/WM phase'
    [[ $installStage -eq 300 ]] && log 2 'At apps phase'
    [[ $installStage -eq 500 ]] && log 2 'At configuration phase'
    for installFile in $AR_DIR/modules/**/install-$installStage; do
        if [[ $installFile != "$AR_DIR/modules/**/install-$installStage" ]]; then
            source $installFile
            check &> /dev/null
            [[ ! $? -eq 0 ]] && [[ $AR_MODULE != 'install' ]] && log 5 "Didn't run at stage $installStage (Checks failed)"
            [[ $? -eq 1 ]] && install
            export AR_MODULE='install'
        fi
    done
done
