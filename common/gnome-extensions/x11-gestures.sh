#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

if ! [[ -d ./x11-gestures ]]; then
    git clone https://github.com/JoseExposito/gnome-shell-extension-x11gestures.git x11-gestures
else
    (
        cd x11-gestures || exit $?
        git checkout -- .
        git reset --hard
        git pull
    )
fi

cd x11-gestures || exit $?
git apply ../x11-gestures.patch
glib-compile-schemas schemas
mkdir -p "${HOME}/.local/share/gnome-shell/extensions"
cp -rf "$(pwd)" "${HOME}/.local/share/gnome-shell/extensions/x11gestures@joseexposito.github.io"