#!/bin/bash
#compress new acelp .out files into ogg --sq5bpf
TDIR=./in
ODIR=./out
while : ; do
while read a
do
echo "#################################"
EXDATE=`echo "$a"|sed -e 's/.*traffic_\([0-9]*\)_.*/\1/'`
DDIR="$ODIR"
FNTMP=`basename "$a" .out`
FNAME="$DDIR/$FNTMP"
mkdir -p $DDIR
date
#echo $a $EXDATE $FNAME
#               ls -al $a
TMPOUT="${FNAME}.out"
TMPF="${FNAME}.codec"
PCMF="${FNAME}.raw"
WAVF="${FNAME}.wav"
OGGF="${FNAME}.ogg"

mv $a $TMPOUT
cdecoder $TMPOUT $TMPF
sdecoder $TMPF $PCMF
sox -r 8k -e signed -b 16 $PCMF  $WAVF
ffmpeg -i $WAVF $OGGF

rm "$TMPOUT" "$TMPF" "$PCMF" "$WAVF"
echo 


done < <( find $TDIR/ -type f -regex ".*\.out")


	sleep 0.5
	done
