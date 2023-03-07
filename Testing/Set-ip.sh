#!/bin/bash

# Display the available network interfaces
echo "Available network interfaces:"
echo "$(ip link show | awk -F': ' '{print $2}' | grep -v lo)"

# Prompt the user for the network interface name
read -p "Enter the network interface name to configure (e.g. eth0): " iface

# Prompt the user for the network configuration
read -p "Enter the IP address to set (e.g. 192.168.0.100): " ipaddr
read -p "Enter the subnet mask (e.g. 255.255.255.0): " subnet
read -p "Enter the gateway address (e.g. 192.168.0.1): " gateway
read -p "Enter the primary DNS server (e.g. 8.8.8.8): " dns1
read -p "Enter the secondary DNS server (e.g. 8.8.4.4): " dns2

# Prompt the user for the interface priority
read -p "Enter the interface priority (optional, default is 0): " priority

# Set the interface priority to 0 if not provided
if [[ -z $priority ]]; then
  priority=0
fi

# Backup the original network configuration file
cp /etc/network/interfaces /etc/network/interfaces.bak

# Configure the network interface with static IP address
cat << EOF > /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug $iface
iface $iface inet static
    address $ipaddr
    netmask $subnet
    gateway $gateway
    dns-nameservers $dns1 $dns2
    metric $priority
EOF

# Restart the networking service to apply changes
systemctl restart networking