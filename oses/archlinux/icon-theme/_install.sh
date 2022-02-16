#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
yes | makepkg -si