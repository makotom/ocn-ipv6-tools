#!/bin/sh

xl2tpd-control disconnect ocn-ipv6 > /dev/null
kill $(cat /var/run/xl2tpd.pid)
