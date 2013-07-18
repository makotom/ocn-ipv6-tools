#!/bin/sh

LNS=
AID=

until ping -c 1 $LNS > /dev/null 2>&1
do
	sleep 1
done

CONFIG_DIR=$(cd $(dirname $0); pwd)/config

if [ ! -e $CONFIG_DIR ]
then
	mkdir $CONFIG_DIR
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
auth file = /etc/ppp/chap-secret\n\
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

xl2tpd -c $CONFIG_DIR/xl2tpd.conf
sleep 5
xl2tpd-control connect ocn-ipv6 > /dev/null
