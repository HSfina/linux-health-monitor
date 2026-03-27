#!/bin/bash

THRESHOLD=80
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE=~/linux-health-monitor/health.log

DISK_USAGE=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)

echo "[$TIMESTAMP] Disk Usage: ${DISK_USAGE}%" | tee -a $LOG_FILE

if (( $(echo "$DISK_USAGE > $THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] ⚠️  ALERT: Disk at ${DISK_USAGE}%" | tee -a $LOG_FILE
fi
