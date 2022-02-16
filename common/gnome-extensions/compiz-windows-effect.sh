#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

if ! [[ -d ./compiz-windows-effect ]]; then
    git clone https://github.com/hermes83/compiz-windows-effect.git compiz-windows-effect
else
    (
        cd compiz-windows-effect || exit $?
        git checkout -- .
        git reset --hard
        git pull
    )
fi

cd compiz-windows-effect || exit $?
git apply ../compiz-windows-effect.patch
glib-compile-schemas schemas
mkdir -p "${HOME}/.local/share/gnome-shell/extensions"
cp -rf "$(pwd)" "${HOME}/.local/share/gnome-shell/extensions/compiz-windows-effect@hermes83.github.com"


