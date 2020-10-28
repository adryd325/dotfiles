
# set temp dir variable
for AR_OS_TEMPDIR in "$TMPDIR" "$TMP" "$TEMP" /tmp
do
  test -n "$AR_OS_TEMPDIR" && break
done

export AR_DOTFILES_DIR=$PWD
export AR_TEMP_DIR="$AR_OS_TEMPDIR/dotadryd/"
source $AR_DOTFILES_DIR/lib/logger.sh

# # definitely not the best way to check for archiso
# # but for my purposes it works
log 0 'index' 'checking for archiso...'
# lsblk -o name,mountpoint | grep 'loop0 *\/run/archiso/sfs/airootfs$' &> /dev/null
# if [[ $? -eq 0 || true ]]; then
#     log 2 'index' 'detected archiso'
#     $AR_DOTFILES_DIR/utils/archiso.sh
#     log 0 'index' 'archiso script done, shutting down...'
#     init 0
# fi

log 3 'index' 'Starting program install scripts.'
scripts/install/discord.sh 

log 4 'index' 'Starting semi-manual installations.'
scripts/install/flstudio.sh &