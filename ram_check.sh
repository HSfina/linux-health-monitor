#!/bin/bash

THRESHOLD=80
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE=~/linux-health-monitor/health.log
EMAIL="hamssassia9@gmail.com"

TOTAL=$(free | grep Mem | awk '{print $2}')
USED=$(free | grep Mem | awk '{print $3}')
RAM_USAGE=$(echo "scale=2; $USED/$TOTAL*100" | bc)

echo "[$TIMESTAMP] RAM Usage: ${RAM_USAGE}%" | tee -a $LOG_FILE

if (( $(echo "$RAM_USAGE > $THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] ⚠️  ALERT: RAM at ${RAM_USAGE}%" | tee -a $LOG_FILE
    echo -e "To: $EMAIL\nSubject: ⚠️ RAM Alert - $(hostname)\n\nALERT: RAM usage is at ${RAM_USAGE}% on $(hostname)" | msmtp -t
fi
