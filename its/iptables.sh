#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward 

iptables -A FORWARD -i eth0 -o tun0 -p tcp --syn --dport 95 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 95 -j DNAT --to-destination 192.168.1.100
