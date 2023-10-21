#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Backup the IP tables configurations
iptables-save > /etc/iptables.rules

# Remove all installed packages except iptables-persistent
echo "Removing all installed packages except iptables-persistent..."
apt-get purge --auto-remove -y $(dpkg --get-selections | grep -v deinstall | grep -v iptables-persistent | awk '{print $1}')
apt-get autoremove -y
apt-get clean

# Remove all user-created files
echo "Removing all user-created files..."
rm -rf /home/*  # This deletes all user home directories and their contents
rm -rf /root/*  # This deletes the root user's home directory and its contents

# Clean up any remaining files
echo "Cleaning up..."
rm -rf /var/log/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Optionally, you can also remove other configuration files or directories (be careful with this)
# rm -rf /etc/some_directory

# Reboot the server
echo "The server will now reboot."
reboot
