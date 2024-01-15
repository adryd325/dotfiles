#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

if ! lsusb | grep "ID 1df7:3000"; then
    exit 1
fi

STOPPED=0
function stop {
    #killall python2.7 -s 9 2>/dev/null
    killall telive 2>/dev/null
    STOPPED=1
}

trap stop 1
trap stop 2
trap stop 3
trap stop 15

mkdir -p /tmp/telive/out
mkdir -p /tmp/telive/in

ln -sf /tmp/telive/out .
ln -sf /tmp/telive/in .

sudo systemctl restart sdrplay

socat -b 4096 UDP-RECV:42001 STDOUT \
    | python3 "$(nix-store -q "$(command -v tetra-rx)")"/lib/osmo-tetra-sq5bpf/demod/gnuradio-3.10/simdemod3_py3.py -o /dev/stdout -i /dev/stdin \
    | TETRA_HACK_RXID=1 TETRA_HACK_PORT=7379 tetra-rx -r -s  /dev/stdin &

nix-shell --pure --command 'python3 phys_sdrplay.py' sdrplay.nix &

sleep 5

lxterminal --geometry=203x60 --command='bash -c "nix-shell --command telive" ' &

wait
