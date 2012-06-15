#!/bin/sh

LNS=

PIPE=.ocn-ipv6-pipe

if [ -e $PIPE ]
then
	rm $PIPE
fi

mkfifo $PIPE
nc -l 1701 < $PIPE | nc -u $LNS 1701 > $PIPE &
rm $PIPE

while :
do
	sleep 300
done
