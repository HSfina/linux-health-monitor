#!/bin/bash
# log_analyzer.sh - Analyzes system logs and generates a security report
# Author: Soufiane Hamssassia

# ----------------------------
# Setup
# ----------------------------
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$DIR/config.cfg"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

DATE=$(date "+%Y-%m-%d")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

LOGFILE="$DIR/health.log"
mkdir -p "$(dirname "$LOGFILE")"

echo "================================================" | tee -a "$LOGFILE"
echo "     	LOG ANALYSIS REPORT — $DATE" | tee -a "$LOGFILE"
echo "================================================" | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# ----------------------------
# SECURITY
# ----------------------------
echo "SECURITY" | tee -a "$LOGFILE"
echo "------------------------------------------------" | tee -a "$LOGFILE"

AUTH_LOG="/var/log/auth.log"
if [ -f "$AUTH_LOG" ]; then
    # Count sudo commands by current user today
    CURRENT_USER=$(whoami)
    SUDO_COUNT=$(grep "sudo" "$AUTH_LOG" | grep "$CURRENT_USER" | grep "$(date '+%b %d')" | wc -l)
    echo "    Sudo commands today    : $SUDO_COUNT" | tee -a "$LOGFILE"

    # SSH attempts today
    SSH_FAILED=$(grep "Failed password" "$AUTH_LOG" | grep "$(date '+%b %d')" | wc -l)
    SSH_SUCCESS=$(grep "Accepted" "$AUTH_LOG" | grep "$(date '+%b %d')" | wc -l)

    echo "    Failed SSH attempts    : $SSH_FAILED" | tee -a "$LOGFILE"
    echo "    Successful logins      : $SSH_SUCCESS" | tee -a "$LOGFILE"
else
    echo "    Auth log not found: $AUTH_LOG" | tee -a "$LOGFILE"
fi

# ----------------------------
# ERRORS
# ----------------------------
echo "" | tee -a "$LOGFILE"
echo "ERRORS" | tee -a "$LOGFILE"
echo "-------------------------------------------------" | tee -a "$LOGFILE"

ERR=$(journalctl -p err --since "today" --no-pager 2>/dev/null | awk '{$1=$2=$3=""; msg=$0; gsub(/^ +/, "", msg); if(msg!="") print msg}' | sort | uniq -c | sort -rn | head -3)
if [ -z "$ERR" ]; then
	echo "    Top errors today       : None" | tee -a "$LOGFILE"
else
	echo "    Top errors today       :" | tee -a "$LOGFILE"
	echo "$ERR" | sed 's/^/    /' | tee -a "$LOGFILE"
fi

SSH=$(grep "Failed password" "$AUTH_LOG" 2>/dev/null | awk '{print $11}' | sort | uniq -c | sort -rn | awk '$1 > 5')
if [ -z "$SSH" ]; then
    echo "    Number of repeated failed SSH attempts: None" | tee -a "$LOGFILE"
else
    echo "    Number of repeated failed SSH attempts:" | tee -a "$LOGFILE"
    echo "$SSH" | sed 's/^/    /' | tee -a "$LOGFILE"
fi

# ----------------------------
# SERVICES
# ----------------------------
echo "" | tee -a "$LOGFILE"
echo "SERVICES" | tee -a "$LOGFILE"
echo "-------------------------------------------------" | tee -a "$LOGFILE"

# Health monitor service status
if systemctl list-units --type=service | grep -q "health_monitor.service"; then
    UPTIME=$(systemctl show -p ActiveState,SubState --value health_monitor.service | tr '\n' ' ')
    echo "	Health Monitor         : $UPTIME" | tee -a "$LOGFILE"
else
    echo "	Health Monitor         : Service not found" | tee -a "$LOGFILE"
fi
if [ -z "$UPTIME" ]; then
    echo "	Health Monitor         : Service not found" | tee -a "$LOGFILE"
else
    echo "	Health Monitor         : $UPTIME" | tee -a "$LOGFILE"
fi

# Connected users
USERS=$(who | awk '{print $1}' | sort | uniq -c)
echo "	Connected users        :" | tee -a "$LOGFILE"
echo "$USERS" | awk '{printf "            %s user(s): %s\n", $1, $2}' | tee -a "$LOGFILE"

# Last health check
SERVICE_LOG="$DIR/service.log"
if [ -f "$SERVICE_LOG" ]; then
    LAST_CHECK=$(tail -1 "$SERVICE_LOG" | awk '{print $1, $2}')
    echo "	Last check             : $LAST_CHECK" | tee -a "$LOGFILE"
else
    echo "	Last check             : Service log not found" | tee -a "$LOGFILE"
fi

# Last 5 successful connections
CNX=$(last -n 5 --time-format short)
echo "	Last 5 successful connections:" | tee -a "$LOGFILE"
echo "$CNX" | sed 's/^/    /' | tee -a "$LOGFILE"

# Suspicious processes (CPU > 50%)
SUS_PROCESSES=$(ps aux | awk '$3 > 50 && $11 != "ps" {print $1, $2, $3, $11}')
if [ -z "$SUS_PROCESSES" ]; then
    echo "	Suspicious processes   : None detected" | tee -a "$LOGFILE"
else
    echo "	Suspicious processes   :" | tee -a "$LOGFILE"
    echo "$SUS_PROCESSES" | sed 's/^/            /' | tee -a "$LOGFILE"
fi

echo "" | tee -a "$LOGFILE"
echo "=================================================" | tee -a "$LOGFILE"
echo "Generated : $TIMESTAMP" | tee -a "$LOGFILE"
echo "=================================================" | tee -a "$LOGFILE"
echo -e "\n\n" | tee -a "$LOGFILE"
