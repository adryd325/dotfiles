# set temp dir variable
for AR_OS_TEMPDIR in "$TMPDIR" "$TMP" "$TEMP" /tmp
do
  test -n "$AR_OS_TEMPDIR" && break
done

# make things quiets
export AR_TTY=/dev/null
[[ DEBUG ]] && export AR_TTY=$(tty)

export AR_DIR="$HOME/.adryd"
export AR_TMP="$AR_OS_TEMPDIR/dotadryd/"
source $AR_DIR/lib/logger.sh

log 0 'index' 'Detecting archiso...'
if [[ $HOSTNAME == 'archiso' ]]; then
    log 2 'index' 'Detected archiso. Running Arch install script.'
    $AR_DIR/modules/archinstall/index.sh
    log 0 'index' 'Arch install script done, shutting down...'
    [[ $AR_TESTING != true ]] && halt
fi