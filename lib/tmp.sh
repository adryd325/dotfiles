if [ ! $AR_TMP ]; then
    for osTempDir in `mktemp 2> /dev/null` "$TMPDIR" "$TMP" "$TEMP" /tmp; do
        [ -e "$osTempDir" ] \
            && export AR_TMP=$osTempDir/adryd-dotfiles \
            && break
    done
    [ ! $AR_TMP ] \
        && log error "Could not find temp folder" \
        && exit 1
fi
