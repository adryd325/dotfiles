#!/usr/bin/env bash
# shellcheck disable=2154
export DISCORD_BRANCHES=("stable" "ptb" "canary" "development")

DOWNLOAD_ENDPOINT='https://discord.com/api/download'
DOWNLOAD_OPTIONS='?platform=linux&format=tar.gz'
function getDiscordDownloadURL {
    if [[ "$1" = "stable" ]] || [[ -z "$1" ]]; then
        echo "${DOWNLOAD_ENDPOINT}${DOWNLOAD_OPTIONS}"
    else
        echo "${DOWNLOAD_ENDPOINT}/$1${DOWNLOAD_OPTIONS}"
    fi
}

function isValidBranch {
    invalid=1
    for i in "${DISCORD_BRANCHES[@]}"; do
        if [[ "${i}" = "$1" ]]; then
            invalid=0
        fi
    done
    return "${invalid}"
}

function getDiscordName {
    branch=$1
    if [[ "${branch}" = "stable" ]]; then
        echo "Discord"
    elif [[ "${branch}" = "ptb" ]]; then
        echo "DiscordPTB"
    else
        echo "Discord${branch^}"
    fi
}

function getDiscordPrettyName {
    branch=$1
    if [[ "${branch}" = "stable" ]]; then
        echo "Discord"
    elif [[ "${branch}" = "ptb" ]]; then
        echo "Discord PTB"
    else
        echo "Discord ${branch^}"
    fi
}

function getDiscordPkgName {
    branch=$1
    if [[ "${branch}" = "stable" ]]; then
        echo "discord"
    else
        echo "discord-${branch}"
    fi
}
