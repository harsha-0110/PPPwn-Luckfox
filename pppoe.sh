#!/bin/bash
##############################
# Simple script that starts PPPoE Server
##############################

sudo ip link set eth0 down
sleep 2
sudo ip link set eth0 up

# Set Firewall rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
sudo sysctl net.ipv4.ip_forward=1
sudo sysctl net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -F POSTROUTING
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Start PPPoE Server
sudo pppoe-server -I eth0 -T 60 -N 1 -C isp -S isp -L 10.1.1.1 -R 10.1.1.2 -F
