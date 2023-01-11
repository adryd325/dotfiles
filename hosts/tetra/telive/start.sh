#!/usr/bin/env bash
cd "$(dirname "$0")" || exit $?

if ! lsusb | grep "0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T"; then
    exit 1
fi

STOPPED=0
function stop {
    killall python2.7 -s 9 2>/dev/null
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

socat -b 4096 UDP-RECV:42001 STDOUT \
    | ( python2.7 "$(nix-store -q "$(command -v tetra-rx)")"/lib/osmo-tetra-sq5bpf/demod/python-3.7/simdemod2.py -o /dev/stdout -i /dev/stdin & echo $! >&3 ) 3>pid  \
    | TETRA_HACK_RXID=1 TETRA_HACK_PORT=7379 tetra-rx -a -r -s -i /dev/stdin &

python2.7 ./phys.py &
lxterminal --geometry=203x60 --command='bash -c "nix-shell --command telive" ' &

while lsusb | grep "0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T" &>/dev/null; do
    sleep 0.1;
    if [[ "${STOPPED}" = "1" ]]; then
        break;
    fi
done

stop
wait
