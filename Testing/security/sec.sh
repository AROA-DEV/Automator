#!/bin/bash

YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

SEC_LOG_DIR="/root/log/security-log/$YEAR/$MONTH/$DAY/"
PREV_MONTH=$(date -d "last month" +%m)
PREV_YEAR=$(date -d "last month" +%Y)
PREV_MONTH_LOG_DIR="/root/log/security-log/$PREV_YEAR/$PREV_MONTH/"

mkdir -p "$SEC_LOG_DIR"

# Update ClamAV virus definitions
freshclam

# Scan the full system with ClamAV and save the output to a file
clamscan -r / | tee "$SEC_LOG_DIR/scan.log"

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

# Scan the system with debsecan and save the output to a file
sudo debsecan | tee "$SEC_LOG_DIR/debsecan.log"

# Check the last login attempts and save the output to a file
sudo lastb | tee "$SEC_LOG_DIR/lastb.log"

# Output a message indicating the scan is complete
echo "Security scans complete. Check the log files in '$SEC_LOG_DIR' for details."

# On the 1st day of the month, tar.gz the previous month's logs and delete them
if [[ $DAY -eq 1 ]]; then
    PREV_MONTH_TAR_FILE="/root/log/security-log/$PREV_YEAR/$PREV_MONTH.tar.gz"
    tar -zcf "$PREV_MONTH_TAR_FILE" "$PREV_MONTH_LOG_DIR"
    rm -rf "$PREV_MONTH_LOG_DIR"
fi
