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
if [[ $HOSTNAME == 'archiso' && $USER == 'root' ]]; then
    log 2 'index' 'Detected archiso. Running Arch install script.'
    $AR_DIR/modules/archinstall/index.sh
    log 0 'index' 'Arch install script done, shutting down...'
    [[ $AR_TESTING != true ]] && halt
fi

log 0 'index' 'Detecting LXC...'
cat /etc/os-release | grep "NAME=Fedora" > /dev/null
if [[ $? -eq 0 && $(systemd-detect-virt) == 'lxc' && $USER= ]]; then
    log 2 'index' 'Detected LXC. Running LXC setup script.'
    $AR_DIR/modules/ctsetup/index.sh
    log 0 'index' 'Arch LXC script done. exiting'
    exit 0
fi
