#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward 

PORTS="25 79 95"

iptables -F
iptables -F -t nat

for i in $PORTS; do
    iptables -A FORWARD -i eth0 -o tun0 -p tcp --syn --dport $i -m conntrack --ctstate NEW -j ACCEPT
    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $i -j DNAT --to-destination 192.168.1.100
done

iptables -A FORWARD -i eth0 -o tun0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
