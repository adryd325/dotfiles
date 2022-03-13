#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ./versions.sh
source ../../lib/temp.sh
source ../../lib/download.sh
source ../../lib/log.sh
source ../../lib/os.sh
export AR_MODULE="discord"

tempDir=$(mkTemp)

if [[ "$(getDistro)" == "macos" ]]; then
    log error "Incompatible with macOS"
    exit 1
fi

function installBranch {
    branch=$1
    AR_LOG_PREFIX="${branch}"
    name=$(getDiscordName "${branch}")
    pkgName=$(getDiscordPkgName "${branch}")
    installationDir="${HOME}/.local/share/${name}"
    desktopFile="${HOME}/.local/share/${name}/${pkgName}.desktop"

    log info "Downloading"
    if ! download "$(getDiscordDownloadURL "${branch}")" "${tempDir}/${name}.tar.gz"; then
        log error "Failed to download"
        return 1
    fi

    if [[ -d "${installationDir}" ]]; then
        log info "Deleting existing installation"
        rm -rf "${installationDir}"
    fi

    log info "Extracting"
    tar -xf "${tempDir}/${name}.tar.gz" -C "${HOME}/.local/share" || return

    log info "Installing"

    # The new (May 2021) icon looks too big on the GNOME dock
    if [[ -x "$(command -v convert)" ]]; then
        log verb "Add margin to the icon"
        convert \
            "${installationDir}/discord.png" \
            -bordercolor Transparent \
            -compose copy \
            -border 16 \
            -resize 256x256 \
            "${installationDir}/discord.png"
    fi
    # Check to make sure no existing icons exist
    log verb "Installing icon"
    mkdir -p "${HOME}/.local/share/icons/hicolor/256x256"
    cp -f "${installationDir}/discord.png" "${HOME}/.local/share/icons/hicolor/256x256/${pkgName}.png" &> /dev/null

    log verb "Patching .desktop file"
    sed -i "s:Exec=/usr/share/${pkgName}/${name}:Exec=\"${installationDir}/${name}\" --ignore-gpu-blocklist --ignore-gpu-blacklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-mjpeg-decode --enable-accelerated-video --disable-gpu-driver-bug-workarounds --enable-native-gpu-memory-buffer --no-sandboxs:" \
        "${desktopFile}"
    sed -i "s/StartupWMClass=discord/StartupWMClass=${name}/" \
        "${desktopFile}"
    sed -i "s:Icon=${pkgName}:Icon=${HOME}/.local/share/icons/hicolor/256x256/${pkgName}.png:" \
        "${desktopFile}"
    sed -i "s:Path=/usr/bin:path=${installationDir}:" \
        "${desktopFile}"

    # Copy over new .desktop files
    log verb "Installing .desktop file"
    mkdir -p "${HOME}/.local/share/applications"
    cp -f "${installationDir}/${pkgName}.desktop" "${HOME}/.local/share/applications/${pkgName}.desktop"
}

case "$(getDistro)" in
    "archlinux")
        ensureInstalled glibc alsa-lib gcc-libs libnotify nspr nss libxss libxtst libc++
        ;;
    "debian")
        ensureInstalled libc6 libasound2 libatomic1 libgconf-2-4 libnotify4 libnspr4 libnss3 libstdc++6, libxss1 libxtst6 libappindicator1 libc++1
        ;;
    "fedora")
        ensureInstalled glibc alsa-lib GConf2 libX11 libXtst libappindicator libatomic libnotify nspr nss
        ;;
    *)
        # Do nothing
        true;
        ;;
esac

if [[ $# -gt 0 ]]; then
    for branch in "$@"; do
        if ! isValidBranch "${branch}"; then
            log warn "The branch \"${branch}\" does not exist"
            continue
        fi
        installBranch "${branch}" &
    done
    wait
else
    installBranch stable
fi

unset AR_LOG_PREFIX