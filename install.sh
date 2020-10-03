#!/bin/bash

# detect archiso and run archiso scripts
if lsblk -o name,mountpoint | grep 'arch_iso *\/$'; then
    ./opt/archinstall/archiso.sh
fi