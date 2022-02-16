#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

if ! [[ -d ./just-perfection ]]; then
    git clone https://gitlab.gnome.org/jrahmatzadeh/just-perfection.git just-perfection
else
    (
        cd just-perfection || exit $?
        git checkout -- .
        git reset --hard
        git pull
    )
fi

cd just-perfection|| exit $?
./scripts/build.sh -i