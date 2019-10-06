cd ~
curl -fsSL https://codeload.github.com/Homebrew/install/zip/master > brew.zip # raw.githubusercontent.com is blocked
unzip brew.zip
/usr/bin/ruby -e "$(cat ~/install-master/install)" 
rm -rf ./brew.zip
rm -rf ./install-master