# require powerline-fonts
if [[ $AR_OS == "arch" && require powerline-fonts ]]; then
    echo "FONT=ter-powerline-v32b" | sudo tee /etc/vconsole.conf
fi