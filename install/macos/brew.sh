cd ~
curl -fsSL https://codeload.github.com/Homebrew/install/zip/master > brew.zip # raw.githubusercontent.com is blocked
unzip brew.zip
/usr/bin/ruby -e "$(cat ~/install-master/install)"
read  -n 1 -p "press any key once brew is done" 
rm -rf ./brew.zip
rm -rf ./install-master