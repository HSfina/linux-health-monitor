#!/bin/bash
# monitor_checks.sh - Unified system resource monitoring
# Author: Soufiane Hamssassia
# Description: Monitors CPU, RAM, Disk usage, and Network status, logs results, and sends alert emails.

# ----------------------------
# Setup
# ----------------------------
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/config.cfg"
mkdir -p "$(dirname "$LOGFILE")"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
HOSTNAME=$(hostname)

# ----------------------------
# Generic log + alert function
# ----------------------------
log_and_alert() {
    local metric="$1"
    local value="$2"
    local threshold="$3"
    local unit="$4"
    local alert_msg="$5"

    echo "[$TIMESTAMP] $metric Usage: $value$unit" | tee -a "$LOGFILE"

    # Only send alert if threshold is exceeded
    if [ "${value%.*}" -gt "$threshold" ]; then
        echo "[$TIMESTAMP] ⚠️ ALERT: $metric at $value$unit" | tee -a "$LOGFILE"
        if [ -n "$EMAIL" ]; then
            echo -e "To: $EMAIL\nSubject: ⚠️ $metric Alert - $HOSTNAME\n\n$alert_msg" | msmtp -t 2>>"$LOGFILE"
        else
            echo "[$TIMESTAMP] EMAIL not configured. Cannot send alert for $metric." | tee -a "$LOGFILE"
        fi
    fi
}

# ----------------------------
# CPU Monitoring
# ----------------------------
CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
log_and_alert "CPU" "$CPU_USAGE" "$CPU_THRESHOLD" "%" "CPU usage is at $CPU_USAGE%"

# ----------------------------
# RAM Monitoring
# ----------------------------
read -r TOTAL USED <<< $(free -m | awk '/Mem:/ {print $2,$3}')
RAM_USAGE=$(awk "BEGIN {printf \"%.2f\", ($USED/$TOTAL)*100}")
log_and_alert "RAM" "$RAM_USAGE" "$RAM_THRESHOLD" "%" "RAM usage is at $RAM_USAGE%"

# ----------------------------
# Disk Monitoring
# ----------------------------
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
log_and_alert "Disk" "$DISK_USAGE" "$DISK_THRESHOLD" "%" "Disk usage is at $DISK_USAGE%"

# ----------------------------
# Network Monitoring
# ----------------------------
if ping -c 1 -W 5 8.8.8.8 > /dev/null 2>&1 || ping -c 1 -W 5 1.1.1.1 > /dev/null 2>&1; then
    echo "[$TIMESTAMP] Network Status: UP" | tee -a "$LOGFILE"
else
    echo "[$TIMESTAMP] Network Status: DOWN" | tee -a "$LOGFILE"
    if [ -n "$EMAIL" ]; then
        echo -e "To: $EMAIL\nSubject: ⚠️ Network Alert - $HOSTNAME\n\nALERT: Internet is DOWN on $HOSTNAME at $TIMESTAMP" | msmtp -t 2>>"$LOGFILE"
    else
        echo "[$TIMESTAMP] EMAIL not configured. Cannot send network alert." | tee -a "$LOGFILE"
    fi
fi

# ----------------------------
# End of monitoring
# ----------------------------
echo -e "\n" >> "$LOGFILE"
