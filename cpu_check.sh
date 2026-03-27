#!/bin/bash

THRESHOLD=80
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE=~/linux-health-monitor/health.log

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)

echo "[$TIMESTAMP] CPU Usage: ${CPU_USAGE}%" | tee -a $LOG_FILE

if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] ⚠️  ALERT: CPU at ${CPU_USAGE}%" | tee -a $LOG_FILE
fi
