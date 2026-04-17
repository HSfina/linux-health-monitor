#!/bin/bash
# rotate_log.sh - Rotate and clean old logs safely

DIR="$HOME/linux-health-monitor"
LOG_FILE="$DIR/health.log"
DATE=$(date +"%Y-%m-%d")
ARCHIVE_LOG="$DIR/health_$DATE.log"

# Ensure directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory $DIR does not exist"
    exit 1
fi

# Rotate log if it exists
if [ -f "$LOG_FILE" ]; then
    mv "$LOG_FILE" "$ARCHIVE_LOG"
    echo "Log archived: $ARCHIVE_LOG"
else
    echo "No log file to archive"
fi

# Create new log file
touch "$LOG_FILE" || 
	{
		echo "Error: Failed to create new log file"
    		exit 1
	}
echo "New log file created: $LOG_FILE"

# Delete old archived logs ONLY (not current log)
find "$DIR" -name "health_*.log" -mtime +7 -type f -print -delete

echo "Old logs (>7 days) deleted"
