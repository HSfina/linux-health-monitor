#!/bin/bash

source ~/linux-health-monitor/config.cfg

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

TOTAL=$(free | grep Mem | awk '{print $2}')
USED=$(free | grep Mem | awk '{print $3}')
RAM_USAGE=$(echo "scale=2; $USED/$TOTAL*100" | bc)

echo "[$TIMESTAMP] RAM Usage: ${RAM_USAGE}%" | tee -a $LOGFILE

if (( $(echo "$RAM_USAGE > $RAM_THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] ⚠️  ALERT: RAM at ${RAM_USAGE}%" | tee -a $LOGFILE
    echo -e "To: $EMAIL\nSubject: ⚠️ RAM Alert - $(hostname)\n\nALERT: RAM usage is at ${RAM_USAGE}% on $(hostname)" | msmtp -t
fi
