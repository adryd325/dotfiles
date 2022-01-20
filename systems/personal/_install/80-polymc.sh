#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="polymc"

if [ "${AR_OS}" == "linux_arch" ] && pacman -Q polymc-git &> /dev/null; then
    # Make multimc dir if it doesn't already exist
    [ -e "${HOME}/.local/share/polymc" ] \
        || mkdir -p "${HOME}/.local/share/polymc"

    # If the multimc config doesn't already exist
    if [ ! -e "${HOME}/.local/share/polymc/polymc.cfg" ]; then
        # Copy the default config in place
        cp "${AR_DIR}/systems/personal/${AR_MODULE}/polymc.cfg" "${HOME}/.local/share/polymc/polymc.cfg" \
            && log info "Installing polymc config"

        # If we're on popsicle, add additional options for nvidia optimus and more ram availibility
        [ "${HOSTNAME}" == "popsicle" ] \
            && cat "${AR_DIR}/systems/personal/${AR_MODULE}/polymc-popsicle.cfg" >> "${HOME}/.local/share/polymc/polymc.cfg" \
            && log info "Installing popsicle-specific config"
    fi

    # Use integrated GPU since we have prime-run or cursed-mc-run
    log info "Set use IGPU in .desktop file"
    sudo sed "s/PrefersNonDefaultGPU=true/PrefersNonDefaultGPU=false/" /usr/share/applications/org.polymc.PolyMC.desktop

fi
