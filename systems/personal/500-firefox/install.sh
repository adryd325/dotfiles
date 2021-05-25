#!/bin/bash
# I think the funniest thing about this, is you get the "welcome to firefox" message and the browser is already themed and half configured
source $HOME/.adryd/constants.sh
source $AR_DIR/lib/os.sh
AR_MODULE="firefox"

if [ "$AR_OS" == "linux_arch" ]; then
    oldPwd=$PWD
    log info "Starting Firefox to generate profiles"
    firefox-developer-edition -headless -silent &> /dev/null & ffPid=$!
    sleep 5 && kill "$ffPid"

    [ ! -e "$HOME/.local/share/firefox-gnome-theme" ] \
        && mkdir -p "$HOME/.local/share" \
        && log info "Cloning firefox-gnome-theme" \
        && git clone https://github.com/rafaelmardojai/firefox-gnome-theme.git $HOME/.local/share/firefox-gnome-theme --quiet -b beta

    if [ -e "$HOME/.local/share/firefox-gnome-theme" ]; then
        cd "$HOME/.local/share/firefox-gnome-theme"
        git pull --ff-only --quiet
        cd "$oldPwd"
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
            AR_LOG_PREFIX="$profilePath"
            # Move to work dir
            cd "$HOME/.mozilla/firefox/$profilePath"

            [ ! -e "./chrome" ] \
                && mkdir -p chrome \
                && log info "Creating chrome dir"
            cd chrome
            
            [ ! -e "$PWD/firefox-gnome-theme" ] \
                && ln -sF "$HOME/.local/share/firefox-gnome-theme" $PWD \
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
            ln -sf "$AR_DIR/systems/personal/500-firefox/user.js" user.js \
                && log info "Installed user.js"
        done
        AR_LOG_PREFIX=""
    fi  
    cd "$oldPwd"
fi
