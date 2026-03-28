#!/bin/bash

source ~/linux-health-monitor/config.cfg

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

DISK_USAGE=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)

echo "[$TIMESTAMP] Disk Usage: ${DISK_USAGE}%" | tee -a $LOGFILE

if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] ⚠️  ALERT: Disk at ${DISK_USAGE}%" | tee -a $LOGFILE
    echo -e "To: $EMAIL\nSubject: ⚠️ Disk Alert - $(hostname)\n\nALERT: Disk usage is at ${DISK_USAGE}% on $(hostname)" | msmtp -t
fi
