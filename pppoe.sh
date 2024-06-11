#!/bin/bash
##############################
# Simple script that starts PPPoE Server
##############################

# Enable IP Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Start PPPoE Server
pppoe-server -C isp -L 192.168.1.1 -R 192.168.1.2 -p /etc/ppp/ipaddress_pool -I eth0 -m 1412

# Set Firewall rules
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE