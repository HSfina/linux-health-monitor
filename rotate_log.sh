#!/bin/bash

DATE=$(date +"%Y-%m-%d")

LOG_FILE=~/linux-health-monitor/health.log
LOG_DIR=$(dirname "$LOG_FILE")
ARCHIVE_LOG="$LOG_DIR/health_$DATE.log"

if [ -f "$LOG_FILE" ]; then
	mv "$LOG_FILE" "$ARCHIVE_LOG"
	echo "THE LOG FILE IS IN: $ARCHIVE_LOG"
else
	echo "THERE IS NO LOG TO BE ARCHIVED"
fi

touch "$LOG_FILE"
echo "A NEW LOG FILE IS CREATED IN: $LOG_FILE"

find "$LOG_DIR" -name "*.log" -mtime +7 -delete
echo "THE OLD LOGS HAS BEEN DELETED"

