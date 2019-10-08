echo "\033[0;32m#####"
echo "\033[0;32m####\033[0;33m  .adryd"
echo "\033[0;32m###"
echo "\033[0;39m"
echo "Waiting 10 seconds before installation"
sleep 10
echo ""

all () {
  ~/.adryd/install/global/unwravel.sh 
}

KERNEL="$(uname -s)"
if [[ $KERNEL = "Darwin" ]]
then 
  echo "detected macOS"
  export OS="mac"
  ~/.adryd/install/macos/brew.sh 
  ~/.adryd/install/macos/packages.sh
  ~/.adryd/install/macos/preferences.sh
  ~/.adryd/install/macos/unwravel.sh
  all()
elif [[ $KERNEL = "Linux" ]]
then
  cat /etc/os-release | grep NAME=\"Ubuntu\" &> /dev/null
  if [[ $? -eq 0 ]]; then
    echo "detected Ubuntu"
    export OS="ubuntu"
    ~/.adryd/install/ubuntu/packages.sh
    ~/.adryd/install/ubuntu/unwravel.sh 
    all() 
  else
    echo "unsupported"
    exit 1
  fi
else 
  echo "unsupported"
  exit 1
fi