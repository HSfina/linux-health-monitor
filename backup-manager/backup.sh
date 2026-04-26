#!/bin/bash

DIR="$HOME/linux-health-monitor/backup-manager"
source "$DIR/backup.cfg"

DATE=$(date "+%Y-%m-%d_%H-%M-%S")

if [ ! -d "$SOURCE_DIR" ]; then
    echo "$DATE - ERROR: Source directory $SOURCE_DIR not found" >> "$LOG_FILE"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

cd "$(dirname "$SOURCE_DIR")" || exit 1
SOURCE_NAME=$(basename "$SOURCE_DIR")

if tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" "$SOURCE_NAME"; then
    echo "$DATE - Backup successful" >> "$LOG_FILE"
    SIZE=$(du -sh "$BACKUP_DIR/backup_$DATE.tar.gz" | cut -f1)
    echo -e "To: $EMAIL\nSubject: Backup Success\n\nBackup completed at $DATE\nFile: backup_$DATE.tar.gz\nSize: $SIZE" | msmtp -t

else
    echo "$DATE - Backup failed" >> "$LOG_FILE"
    echo -e "To: $EMAIL\nSubject: Backup Error\n\nBackup failed at $DATE on $(hostname)" | msmtp -t

fi

find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
echo "$DATE - Cleanup: removed backups older than $RETENTION_DAYS days" >> "$LOG_FILE"

