echo "\033[0;32m#####"
echo "\033[0;32m####\033[0;33m  .adryd"
echo "\033[0;32m###"
echo "\033[0;39m"
echo "Waiting 10 seconds before installation"
sleep 10
echo ""
KERNEL="$(uname -s)"
if [[ $KERNEL = "Darwin" ]]
then 
  echo "detected macOS"
  ~/.adryd/install/macos/brew.sh 
  ~/.adryd/install/macos/packages.sh
  ~/.adryd/install/macos/preferences.sh
  ~/.adryd/install/macos/unwravel.sh
elif [[ $KERNEL = "Linux" ]]
then
  cat /etc/os-release | grep NAME=\"Ubuntu\" &> /dev/null
  if [[ $? -eq 0 ]]; then
    echo "detected Ubuntu"
  else
    echo "unsupported"
    exit 1
  fi
else 
  echo "unsupported"
  exit 1
fi