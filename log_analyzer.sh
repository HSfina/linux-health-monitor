#!/bin/bash
# Description: Analyzes system logs and generates a security report


source ~/linux-health-monitor/config.cfg

DATE=$(date "+%Y-%m-%d")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "================================================"
echo "     	LOG ANALYSIS REPORT — $DATE"
echo "================================================"

echo ""
echo "SECURITY"
echo "------------------------------------------------"

SUDO_COUNT=$(grep "sudo" /var/log/auth.log | grep "soufiane" | grep "$(date '+%Y-%m-%d')" | wc -l)
echo "	Sudo commands today    : $SUDO_COUNT"

SSH_FAILED=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "	Failed SSH attempts    : $SSH_FAILED"

SSH_SUCCESS=$(grep "Accepted" /var/log/auth.log | wc -l)
echo "	Successful logins      : $SSH_SUCCESS"

echo ""
echo "ERRORS"
echo "-------------------------------------------------"

ERR=$(journalctl -p err --since "today" --no-pager | awk '{print $5}' | sort | uniq -c | sort -rn | head -3)
echo "	Top errors today	: $ERR"

echo ""
echo "SERVICES"
echo "-------------------------------------------------"

UPTIME=$(systemctl status health_monitor.service | grep "Active:" | awk '{print $2, $3, $4, $5, $6, $7, $8, $9}')
echo "	Health Monitor         : $UPTIME"

LAST_CHECK=$(tail -1 ~/linux-health-monitor/service.log | awk '{print $1, $2}')
echo "	Last check             : $LAST_CHECK"

echo ""
echo "================================================="
echo "Generated : $TIMESTAMP"
echo "================================================="
echo ""
echo ""
echo ""
