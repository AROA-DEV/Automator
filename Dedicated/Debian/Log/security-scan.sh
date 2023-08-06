#!/bin/bash
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
# Logs directory
LOG_DIR="/root/log/$YEAR/$MONTH/$DAY/"
SEC_LOG_DIR="$LOG_DIR/secutiry/"
mkdir -p "$SEC_LOG_DIR"
# Define the mount point directory for the USB 
USB_MOUNT_DIR="/root/Log-USB"

# Scan all ports on the system with nmap and save the output to a file
sudo nmap -sS -O localhost | tee "$SEC_LOG_DIR/nmap.log"
# Scan the system with rkhunter and save the output to a file
sudo rkhunter --check --sk | tee "$SEC_LOG_DIR/rkhunter.log"
# Scan the system with chkrootkit and save the output to a file
sudo chkrootkit | tee "$SEC_LOG_DIR/chkrootkit.log"
# Scan the system with lynis and save the output to a file
sudo lynis audit system | tee "$SEC_LOG_DIR/lynis.log"
# Scan the system with tiger and save the output to a file
sudo tiger | tee "$SEC_LOG_DIR/tiger.log"
# Scan the system with psad and save the output to a file
sudo psad -S | tee "$SEC_LOG_DIR/psad.log"

# Get the current day of the week (0: Sunday, 1: Monday, ..., 6: Saturday)
current_day=$(date +%w)

# Check if it's Sunday (1st day of the week)
if [ "$current_day" -eq 0 ]; then
    # Scan the system with debsecan and save the output to a file
    sudo debsecan | tee "$SEC_LOG_DIR/debsecan.log"
    # Update ClamAV virus definitions
    freshclam | tee "$SEC_LOG_DIR/scan.log"
    # Scan the full system with ClamAV and save the output to a file
    clamscan -r / | tee "$SEC_LOG_DIR/scan.log"
    sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
else
    echo "Not the 1st day of the week. will not run debsecan and ClamAV to save resources."
fi

# Check the last login attempts and save the output to a file
sudo lastb | tee "$SEC_LOG_DIR/lastb.log"

# Mount the USB device to the specified mount point
mkdir -p "$USB_MOUNT_DIR"
mount /dev/sdb1 "$USB_MOUNT_DIR"
# create directories on the usb device
mkdir -p "$USB_MOUNT_DIR/log/$YEAR/$MONTH/$DAY/ssh/"
mkdir -p "$USB_MOUNT_DIR/log/$YEAR/$MONTH/$DAY/secutiry/"
# Copy the log files to the USB mount point
cp -ru "/root/log/" "$USB_MOUNT_DIR" # /root/log/$YEAR/$MONTH/$DAY/ to /root/Log-USB/log/$YEAR/$MONTH/$DAY/
chmod 777 "$USB_MOUNT_DIR/log"
# Unmount the USB device
umount "$USB_MOUNT_DIR"