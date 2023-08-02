#!/bin/bash
# Get the current date in YYYY-MM-DD format
DATE=$(date +%F)
# Extract the year and month from the current date
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

# Set the log file paths
UPDATE_LOG_FILE="/root/log/update-log/$DATE.log"
SUCCESS_LOG_FILE="/root/log/loging-log/accepted/$DATE.log"
FAILED_LOG_FILE="/root/log/loging-log/denied/$DATE.log"
FULL_LOG_DIR="/root/log/loging-log/full-log"
FULL_LOG_FILE="$FULL_LOG_DIR/$DATE.log"
MONTHLY_LOG_DIR="$FULL_LOG_DIR/$YEAR-$MONTH"
MONTHLY_ZIP_FILE="$FULL_LOG_DIR/$YEAR-$MONTH.zip"
SEC_LOG_DIR="/root/log/security-log/$YEAR/$MONTH/$DAY/"
# Define the mount point directory for the USB 
USB_MOUNT_DIR="/root/Log-USB"

# Update the system and log the output
apt update -y >> "$UPDATE_LOG_FILE" 2>&1
apt upgrade -y >> "$UPDATE_LOG_FILE" 2>&1

# Create the monthly log directory if it doesn't exist
mkdir -p "$MONTHLY_LOG_DIR"

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

# Move the current day's log file to the monthly log directory
mv "$FULL_LOG_FILE" "$MONTHLY_LOG_DIR/"
# If it's the last day of the month, create a zip file with all logs for the month
if [[ $(date -d "+1 day" +%d) == "01" ]]; then
    # Zip all the logs from the current month into the monthly zip file
    zip -j "$MONTHLY_ZIP_FILE" "$MONTHLY_LOG_DIR"/*.log
fi
# If it's the last day of the month, delete log files from the previous month
if [[ $(date -d "+1 day" +%d) == "01" ]]; then
    find /root/log/update-log -name "*.log" -mtime +30 -delete
    find /root/log/loging-log/accepted -name "*.log" -mtime +30 -delete
    find /root/log/loging-log/denied -name "*.log" -mtime +30 -delete
    rm -rf "$MONTHLY_LOG_DIR"
fi

# Mount the USB device to the specified mount point
mkdir -p "$USB_MOUNT_DIR"
mount /dev/sdb1 "$USB_MOUNT_DIR"
# Copy the log files to the USB mount point
cp -ru "$MONTHLY_LOG_DIR" "$USB_MOUNT_DIR"
cp -ru "$SEC_LOG_DIR" "$USB_MOUNT_DIR"
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