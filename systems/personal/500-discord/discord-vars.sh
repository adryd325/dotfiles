#!/bin/bash
source $HOME/.adryd/constants.sh

downloadURL="$downloadEndpoint/$branch$downloadOptions"
discordName="Discord${branch^}"
discordLowercase="discord-$branch"
if [ "$branch" == "stable" ] || [ "$branch" == "" ]; then
    downloadURL="$downloadEndpoint$downloadOptions"
    discordName="Discord"
    discordLowercase="discord"
elif [ "$branch" == "ptb" ]; then
    discordName="Discord${branch^^}"
    discordLowercase="discord-$branch"
fi