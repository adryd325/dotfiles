rm -rf dotfiles-testing.tar.gz
BUNDLE_DIR=$PWD
cd ..
tar -cvzf /tmp/dotfiles-testing.tar.gz ./${BUNDLE_DIR##*/}
cd $BUNDLE_DIR
mv /tmp/dotfiles-testing.tar.gz ./
