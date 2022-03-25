#!/usr/bin/env bash
function stop {
    pkill -9 "${PHYS_PID}"
}

trap stop 1
trap stop 2
trap stop 3
trap stop 15

socat -b 4096 UDP-RECV:42001 STDOUT \
    | python2.7 "$(nix-store -q "$(command -v tetra-rx)")"/lib/osmo-tetra-sq5bpf/demod/python-3.7/simdemod2.py -o /dev/stdout -i /dev/stdin \
    | TETRA_HACK_RXID=1 TETRA_HACK_PORT=7379 tetra-rx -a -r -s -i /dev/stdin &
python2.7 ./phys.py &
PHYS_PID=$!
lxterminal --geometry=203x60 --command='bash -c "telive"' &

wait
