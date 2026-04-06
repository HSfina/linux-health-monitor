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

SSH=$(grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn | awk '$1 > 5')
echo "	Number of failed SSH	: $SSH"

echo ""
echo "SERVICES"
echo "-------------------------------------------------"

UPTIME=$(systemctl status health_monitor.service | grep "Active:" | awk '{print $2, $3, $4, $5, $6, $7, $8, $9}')
echo "	Health Monitor         : $UPTIME"

USERS=$(who | awk '{print $1}' | sort | uniq -c)
echo "	Connected users at the moment : $USERS"

LAST_CHECK=$(tail -1 ~/linux-health-monitor/service.log | awk '{print $1, $2}')
echo "	Last check             : $LAST_CHECK"

CNX=$(last -n 5)
echo "	Last 5 successful connections	: $CNX"

SUS_PROCCESSES=$(ps aux | awk '$3 > 50 {print $1, $2, $3, $11}')
if [ -z $SUS_PROCCESSES ]; then
	echo "	Suspicious processes	: None detected"
else
	echo "	Suspicious processes  : ⚠️  $SUS_PROCESSES"
fi

echo ""
echo "================================================="
echo "Generated : $TIMESTAMP"
echo "================================================="
echo ""
echo ""
echo ""
