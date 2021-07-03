#!/usr/bin/env bash
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
source $AR_DIR/lib/tmp.sh
AR_MODULE="mutter-performance"

if [ "$AR_OS" == "linux_arch" ]; then
    workDir="$AR_TMP/mutter-performance"
    [ -e "$workDir" ] && rm -rf "$workDir"
    log silly "Making workdir"
    mkdir -p "$workDir"
    log info "Cloning"
    git clone https://aur.archlinux.org/mutter-performance.git "$workDir" --quiet
    log info "Patching PKGBUILD"
    # fixes FPS issues on Intel iGPU
    sed -i "s/_merge_requests_to_use=()/_merge_requests_to_use=('1441')/" "$workDir/PKGBUILD"
    # fixes builds failing cause of no dbus or whatever
    sed -i 's/meson test -C build --print-errorlogs//' "$workDir/PKGBUILD"
    oldPwd=$(pwd)
    cd "$workDir"
    log info "Compiling and installing"
    # only way to get it to install unattended
    yes | makepkg -si
    cd "$oldPwd"
fi
