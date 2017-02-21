#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward 
modprobe nf_conntrack_ftp
modprobe nf_nat_ftp

IP=192.168.1.100
GW=188.114.255.79
INCOMING="25 79 83 95"
OUTGOING="21"
CHAOS=42042

iptables -F
iptables -F -t nat

for i in $INCOMING; do
    iptables -A FORWARD -d $IP -p tcp --syn --dport $i -m conntrack --ctstate NEW -j ACCEPT
    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $i -j DNAT --to-destination $IP
done

for i in $OUTGOING; do
    iptables -A FORWARD -s $IP -p tcp --syn --dport $i -m conntrack --ctstate NEW -j ACCEPT
    iptables -t nat -A POSTROUTING -o eth0 -p tcp --dport $i -j SNAT --to-source $GW
done

iptables -A FORWARD -p udp -m udp --dport $CHAOS -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p udp --dport $CHAOS -j DNAT --to-destination $IP
iptables -t nat -A POSTROUTING -o eth0 -p udp --dport $CHAOS -j SNAT --to-source $GW

iptables -A FORWARD -s $IP -p udp --dport 53 -j ACCEPT

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
