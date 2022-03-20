#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?
source ../../lib/log.sh
source ../../lib/os.sh
source ./package-list.sh

for tap in "${brewTaps[@]}"; do
    brew tap "${tap}"
done

ensureInstalled "${brewPackages[@]}"

for app in "${masPackages[@]}"; do
    mas install "${app}"
done
