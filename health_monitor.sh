#!/bin/bash
# health_monitor.sh - Main system health monitor
# Author: Soufiane Hamssassia
# Description: Orchestrates system resource monitoring and logs results

# ----------------------------
# Setup
# ----------------------------
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/config.cfg"
mkdir -p "$(dirname "$LOGFILE")"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
USERS=$(who | wc -l)

# ----------------------------
# Log header
# ----------------------------
cat <<EOF | tee -a "$LOGFILE"
========================================
[$TIMESTAMP] Starting health check...
[$TIMESTAMP] Server    : $HOSTNAME
[$TIMESTAMP] Uptime    : $UPTIME
[$TIMESTAMP] Users     : $USERS connected
========================================
EOF

# ----------------------------
# Call unified monitoring script
# ----------------------------
# monitor_checks.sh handles CPU, RAM, Disk, and Network checks
if bash "$DIR/monitor_checks.sh"; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Monitoring completed successfully" | tee -a "$LOGFILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Monitoring script failed!" | tee -a "$LOGFILE"
fi

# ----------------------------
# Footer / spacing
# ----------------------------
echo -e "\n" >> "$LOGFILE"
