#!/usr/bin/env bash
# shellcheck disable=2154
export DISCORD_BRANCHES=("stable" "ptb" "canary" "development")

DOWNLOAD_ENDPOINT='https://discord.com/api/download'
DOWNLOAD_OPTIONS='?platform=linux&format=tar.gz'
function getDiscordDownloadURL {
    if [[ "$1" = "stable" ]] || [[ -z "$1" ]]; then
        printf %s%s "${DOWNLOAD_ENDPOINT}" "${DOWNLOAD_OPTIONS}"
    else
        printf %s/%s%s "${DOWNLOAD_ENDPOINT}" "$1" "${DOWNLOAD_OPTIONS}"
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
        printf "Discord"
    elif [[ "${branch}" = "ptb" ]]; then
        printf "DiscordPTB"
    else
        printf "Discord%s" "${branch^}"
    fi
}

function getDiscordPrettyName {
    branch=$1
    if [[ "${branch}" = "stable" ]]; then
        printf "Discord"
    elif [[ "${branch}" = "ptb" ]]; then
        printf "Discord PTB"
    else
        printf "Discord %s" "${branch^}"
    fi
}

function getDiscordPkgName {
    branch=$1
    if [[ "${branch}" = "stable" ]]; then
        printf "discord"
    else
        printf "discord-%s" "${branch}"
    fi
}
