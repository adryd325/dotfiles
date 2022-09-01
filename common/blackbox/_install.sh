#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh

if [[ -d ~/.var/app/com.raggesilver.BlackBox/data/blackbox/schemes ]]; then
    cp -f ./mkp.json ~/.var/app/com.raggesilver.BlackBox/data/blackbox/schemes
fi

if [[ -d ~/.var/app/com.raggesilver.BlackBox/config/glib-2.0/settings ]]; then
    cp -f ./keyfile ~/.var/app/com.raggesilver.BlackBox/config/glib-2.0/settings/keyfile
fi
