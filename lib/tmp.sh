if [ ! $AR_TMP ]; then
    if [ -x $(command -v mktemp) ]; then
        export AR_TMP=`mktemp -d -t adryd-dotfiles.XXXXXXXXXX`
    else
        for osTempDir in "$TMPDIR" "$TMP" "$TEMP" /tmp; do
            [ -e "$osTempDir" ] \
                && export AR_TMP="$osTempDir/adryd-dotfiles.$RANDOM" \
                && break
        done
    fi
    [ ! $AR_TMP ] \
        && log error "Could not find temp folder" \
        && exit 1
fi
