#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="polymc"

##
## This whole MultiMC vs PolyMC issue frustrates me. 
## I'm using PolyMC cause it has a QT scaling issue fixed that MultiMC doesn't have
## People on both sides of the situation have done wrong and this is not me choosing sides.
##

if [[ "${AR_OS}" == "linux_arch" ]] && pacman -Q polymc-git &> /dev/null; then

    # Make polymc dir if it doesn't already exist
    [[ -e "${HOME}/.local/share/polymc" ]] \
        || mkdir -p "${HOME}/.local/share/polymc"

    # If the polymc config doesn't already exist
    if [[ ! -e "${HOME}/.local/share/polymc/polymc.cfg" ]]; then
        # Copy the default config in place
        log info "Installing multimc config"
        cp "${AR_DIR}/legacy/personal/${AR_MODULE}/multimc.cfg" "${HOME}/.local/share/polymc/polymc.cfg"

        # If we're on popsicle, add additional options for nvidia optimus and more ram availibility
        if [[ "${HOSTNAME}" == "popsicle" ]]; then
            log info "Installing popsicle-specific config"
            cat "${AR_DIR}/legacy/personal/${AR_MODULE}/multimc-popsicle.cfg" >> "${HOME}/.local/share/polymc/polymc.cfg"
        fi
    fi

    # Use integrated GPU since we have prime-run or cursed-mc-run
    log info "Set use IGPU in .desktop file"
    sudo sed -i "s/PrefersNonDefaultGPU=true/PrefersNonDefaultGPU=false/" /usr/share/applications/org.polymc.polymc.desktop >/dev/null

fi
