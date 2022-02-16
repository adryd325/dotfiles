#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

if ! [[ -d ./unite-shell ]]; then
    git clone https://github.com/hardpixel/unite-shell.git unite-shell
else
    (
        cd unite-shell || exit $?
        git checkout -- .
        git reset --hard
        git pull
    )
fi

cd unite-shell/unite@hardpixel.eu || exit $?
glib-compile-schemas schemas
mkdir -p "${HOME}/.local/share/gnome-shell/extensions"
cp -rf "$(pwd)" "${HOME}/.local/share/gnome-shell/extensions/unite@hardpixel.eu"


