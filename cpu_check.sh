#!/bin/bash

source ~/linux-health-monitor/config.cfg

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)

echo "[$TIMESTAMP] CPU Usage: ${CPU_USAGE}%" | tee -a $LOGFILE

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] ⚠️  ALERT: CPU at ${CPU_USAGE}%" | tee -a $LOGFILE
    echo -e "To: $EMAIL\nSubject: ⚠️ CPU Alert - $(hostname)\n\nALERT: CPU usage is at ${CPU_USAGE}% on $(hostname)" | msmtp -t
fi
