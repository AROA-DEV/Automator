#!/bin/bash
# Extract the year and month from the current date
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
# Previous month and year logs
PREV_MONTH=$(date -d "last month" +%m)
PREV_YEAR=$(date -d "last month" +%Y)
# Set the log directory paths
LOG_DIR="/root/log/$YEAR/$MONTH/$DAY/"
SSH_LOG_DIR="$LOG_DIR/ssh/"
# Set the log file paths
SUCCESS_LOG_FILE="$SSH_LOG_DIR/success.log"
FAILED_LOG_FILE="$SSH_LOG_DIR/failed.log"
FULL_LOG_FILE="$SSH_LOG_DIR/full.log"
UPDATE_LOG_FILE="$LOG_DIR/update-upgrade.log"
# Define the mount point directory for the USB 
USB_MOUNT_DIR="/root/Log-USB"

# Create the monthly and ssh log directoryes if it doesn't exist
mkdir -p "$LOG_DIR"
mkdir -p "$SSH_LOG_DIR"

# Update the system and log the output
apt update -y >> "$UPDATE_LOG_FILE" 2>&1
apt upgrade -y >> "$UPDATE_LOG_FILE" 2>&1

# Filter successful login entries from journalctl and copy them to the log file
journalctl -u ssh --since yesterday --until now --output=short-iso | grep "Accepted" > "$SUCCESS_LOG_FILE"
# Filter failed login entries from journalctl and copy them to the log file
journalctl -u ssh --since yesterday --until now --output=short-iso | grep "Failed" > "$FAILED_LOG_FILE"
# Filter authorization failed entries from journalctl and copy them to the log file
journalctl -u ssh --since yesterday --until now --output=short-iso | grep "Connection closed by" > "$FAILED_LOG_FILE"
# Filter all login attempts from journalctl and copy them to the log file
journalctl -u ssh --since yesterday --until now --output=short-iso | awk '/sshd/ && /Failed password/ { print $0 }' > "$FAILED_LOG_FILE"
# Copy the full log to the log file
journalctl -u ssh --since yesterday --until now > "$FULL_LOG_FILE"

# compress and delete the previous month's logs
if [[ $DAY -eq 1 ]]; then
    PREV_MONTH_LOG_DIR="/root/log/$PREV_YEAR/$PREV_MONTH"
    PREV_MONTH_TAR_FILE="/root/log/$PREV_YEAR/$PREV_MONTH.tar.gz"
    tar -zcf "$PREV_MONTH_TAR_FILE" "$PREV_MONTH_LOG_DIR"
    rm -rf "$PREV_MONTH_LOG_DIR"
fi

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

# Delete all bash history for all users
for user in /home/*; do
    cat /dev/null > "$user/.bash_history"
done
cat /dev/null > /root/.bash_history

# Reboot the system
systemctl reboot