#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
AR_MODULE="pnpm"

log info "Installing pnpm"
npm install -g pnpm --silent
