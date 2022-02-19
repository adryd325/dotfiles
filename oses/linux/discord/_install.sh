#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../../common/discord/versions.sh
source ../../../lib/temp.sh
source ../../../lib/download.sh
source ../../../lib/log.sh
export AR_MODULE="discord"

tempDir=$(mkTemp)

function installBranch {
    branch=$1
    AR_LOG_PREFIX="${branch}"
    name=$(getDiscordName "${branch}")
    pkgName=$(getDiscordPkgName "${branch}")
    installationDir="${HOME}/.local/share/${name}"
    desktopFile="${HOME}/.local/share/${name}/${pkgName}.desktop"

    if [[ -d "${installationDir}" ]]; then
        log info "Deleting existing installation"
        rm -rf "${installationDir}"
    fi  

    log info "Downloading"
    if ! download "$(getDiscordDownloadURL "${branch}")" "${tempDir}/${name}.tar.gz"; then 
        log error "Failed to download"
        return 1
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
    sed -i "s:Exec=/usr/share/${pkgName}/${name}:Exec=\"${installationDir}/${name}\" -ignore-gpu-blocklist --disable-sandbox --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy:" \
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