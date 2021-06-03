#!/usr/bin/env bash
source $HOME/.adryd/constants.sh

downloadURL="$downloadEndpoint/$branch$downloadOptions"
discordName="Discord${branch^}"
discordNameSpace="Discord ${branch^}"
discordLowercase="discord-$branch"
if [ "$branch" == "stable" ] || [ "$branch" == "" ]; then
    downloadURL="$downloadEndpoint$downloadOptions"
    discordName="Discord"
    discordNameSpace="Discord"
    discordLowercase="discord"
elif [ "$branch" == "ptb" ]; then
    discordName="Discord${branch^^}"
    discordNameSpace="Discord ${branch^^}"
    discordLowercase="discord-$branch"
fi