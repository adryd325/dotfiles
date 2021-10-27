#!/usr/bin/env bash
# shellcheck disable=2154

# TODO: migrate to these variables
# downloadURL
# discordName
# discordDisplayName
# discordPackageName
# discordWMClassName

downloadURL="${downloadEndpoint}/${branch}${downloadOptions}"
discordName="Discord${branch^}"
discordNameSpace="Discord ${branch^}"
discordLowercase="discord-${branch}"
if [ "${branch}" == "stable" ] || [ "${branch}" == "" ]; then
    downloadURL="${downloadEndpoint}${downloadOptions}"
    discordName="Discord"
    discordNameSpace="Discord"
    discordLowercase="discord"
elif [ "${branch}" == "ptb" ]; then
    discordName="Discord${branch^^}"
    discordNameSpace="Discord ${branch^^}"
    discordLowercase="discord-${branch}"
fi

export downloadURL
export discordName
export discordNameSpace
export discordLowercase