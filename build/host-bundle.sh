#!/bin/bash
PORT=7777
HOST=10.0.1.2
source $HOME/.adryd/constants.sh
log silly "Deleting old bundle"
rm -rf $AR_DIR/build/out/dotfiles.tar.gz $AR_DIR/build/out/install.sh
cd $AR_DIR
cd ..
log info "Creating bundle"
tar -czvpf /tmp/dotfiles-testing.tar.gz ./${AR_DIR##*/}
mv /tmp/dotfiles-testing.tar.gz $AR_DIR/build/out/dotfiles.tar.gz
echo "AR_DOWNLOAD_HTTP_TAR=\"http://$HOST:$PORT/dotfiles.tar.gz\" AR_DOWNLOAD_HTTP_ARCHIVE_TARGET=\"${AR_DIR##*/}\" AR_DOWNLOAD_REPLACE_EXISTING=1 AR_DOWNLOAD_HTTP_FORCE=1" >> $AR_DIR/build/out/install.sh 
cat $AR_DIR/download.sh >> $AR_DIR/build/out/install.sh

[ -x "$(command -v http-server)" ] \
    && log info "Use this command on test machine" \
    && log info "bash -c \"\$(curl -fsSL http://$HOST:$PORT/install.sh)\"" \
    && http-server $AR_DIR/build/out --port "$PORT" 
