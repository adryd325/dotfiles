#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../../lib/log.sh
export AR_MODULE="power-logs"

log info "Installing scripts"
sudo cp -f ./log-shutdown.sh /usr/local/bin
sudo cp -f ./log-startup.sh /usr/local/bin

log info "Installing systemd unit"
if ! [[ -f /etc/systemd/system/log-startup.service ]]; then
   sudo cp ./log-startup.service /etc/systemd/system/log-startup.service
   log tell "You must add a Discord webhook to /etc/systemd/system/log-startup.service"
fi
sudo systemctl enable log-startup.service
