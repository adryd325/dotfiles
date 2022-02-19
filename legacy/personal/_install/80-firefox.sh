#!/usr/bin/env bash
# shellcheck source=../../../constants.sh
[[ -z "${AR_DIR}" ]] && echo "Please set AR_DIR in your environment" && exit 0; source "${AR_DIR}"/constants.sh
ar_os
AR_MODULE="firefox"
# I think the funniest thing about this, is you get the "welcome to firefox" message as if firefox usually looks like that

if [[ "${AR_OS}" == "linux_arch" ]]; then
    oldPwd=${PWD}
    log info "Starting Firefox to generate profiles"
    firefox-developer-edition -headless -silent &> /dev/null & ffPid=$!
    sleep 2 && kill "${ffPid}" &> /dev/null

    [[ ! -e "${HOME}/.local/share/firefox-gnome-theme" ]] \
        && mkdir -p "${HOME}/.local/share" \
        && log info "Cloning firefox-gnome-theme" \
        && git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git "${HOME}"/.local/share/firefox-gnome-theme --quiet

    if [[ -e "${HOME}/.local/share/firefox-gnome-theme" ]]; then
        cd "${HOME}/.local/share/firefox-gnome-theme" || exit
        log info "Updating"
        git pull --ff-only --quiet
        cd "${oldPwd}" || exit
    fi
    
    # BELOW CODE MODIFIED FROM https://github.com/rafaelmardojai/firefox-gnome-theme/blob/master/scripts/install.sh
    # TODO: rewrite/cleanup

    profilePaths=($(grep -E "^Path=" "$HOME/.mozilla/firefox/profiles.ini" | cut -d "=" -f2-))

    if [ ${#profilePaths[@]} -eq 0 ]; then
        log warn "No profiles found"
    elif [ ${#profilePaths[@]} -eq 1 ]; then
        log verb "One profile found"
        modProfile "${profilePaths[0]}"
    else
        log verb "${#profilePaths[@]} profiles found"
        for profilePath in "${profilePaths[@]}"; do
            AR_LOG_PREFIX="${profilePath}"
            # Move to work dir
            if [[ ! -d "${HOME}/.mozilla/firefox/${profilePath}" ]]; then
                log warn "${profilePath} does not exist"
                continue;
            fi
            cd "${HOME}/.mozilla/firefox/${profilePath}" || exit

            [ ! -e "./chrome" ] \
                && mkdir -p chrome \
                && log info "Creating chrome dir"
            cd chrome || exit
            
            [ ! -e "${PWD}/firefox-gnome-theme" ] \
                && ln -sF "${HOME}/.local/share/firefox-gnome-theme" "${PWD}" \
                && log info "Installing firefox-gnome-theme"

            if [ -e "userChrome.css" ]; then
                # Remove older theme imports
                sed 's/@import "firefox-gnome-theme.*.//g' userChrome.css | sed '/^\s*$/d' > userChrome.css \
                    && log info "Removing older theme imports"
                echo >> "userChrome.css"
            else
                echo >> "userChrome.css"
            fi

            # Import this theme at the beginning of the CSS files.
            sed -i '1s/^/@import "firefox-gnome-theme\/userChrome.css";\n/' userChrome.css \
                && log info "Adding firefox-gnome-theme import to userChrome.css"

            cd ..

            # Symlink user.js to the sync'ed one
            [ -e user.js ] \
                && rm user.js \
                && log verb "Removing old user.js"
            cp "${AR_DIR}/legacy/personal/${AR_MODULE}/user.js" user.js \
                && log info "Installed user.js"
            
            ICCProfile="$(colormgr get-devices | grep 'Metadata:\s*OutputEdidMd5=' | grep -oP '[0-9a-f]{32}')"
            sed -i "s|__REPLACE_ME__ICC_PROFILE_PATH__|${HOME}/.local/share/icc/edid-${ICCProfile}.icc|g" user.js && log info "Applied ICC profile"
        done
        AR_LOG_PREFIX=""
    fi  
    cd "${oldPwd}" || exit
fi
