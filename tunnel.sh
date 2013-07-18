#!/bin/sh

AID=

LNS=127.0.0.1
PORT=63834

CONFIG_DIR=$(cd $(dirname $0); pwd)/config
PIPE=$CONFIG_DIR/pipe

if [ ! -e $CONFIG_DIR ]
then
	mkdir $CONFIG_DIR
fi

if [ -e $PIPE ]
then
	rm $PIPE
fi

ppp_options="+ipv6\n\
lock\n\
noauth\n\
nodefaultroute\n\
noip\n\
noipdefault\n\
unit 128\n\
usepeerdns\n\
user $AID"

xl2tpd_conf="[global]\n\
auth file = /etc/ppp/chap-secrets\n\
port = $PORT\n\
\n\
[lac ocn-ipv6]\n\
lns = $LNS\n\
length bit = yes\n\
require chap = yes\n\
require authentication = yes\n\
hostname = $AID\n\
pppoptfile = $CONFIG_DIR/ppp-options"

echo -e $ppp_options > $CONFIG_DIR/ppp-options
echo -e $xl2tpd_conf > $CONFIG_DIR/xl2tpd.conf

mkfifo $PIPE
nc -u -l 1701 < $PIPE | nc 127.0.0.1 1701 > $PIPE &
rm $PIPE

sleep 6 && xl2tpd-control connect ocn-ipv6 > /dev/null &
xl2tpd -c $CONFIG_DIR/xl2tpd.conf -D
