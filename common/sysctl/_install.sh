#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="sysctl"

log info "Installing sysrq config"
sudo cp -f ./99-sysrq.conf /etc/sysctl.d/99-sysrq.conf