#!/bin/bash
# health_monitor.sh - Main system health monitor
# Author: Soufiane Hamssassia
# Description: Checks CPU, RAM, and Disk usage, Network status and logs results

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
USERS=$(who | wc -l)

echo "========================================" >> $DIR/health.log
echo "[$TIMESTAMP] Starting health check..." >> $DIR/health.log
echo "[$TIMESTAMP] Server	:	$HOSTNAME" >> $DIR/health.log
echo "[$TIMESTAMP] Uptime	:	$UPTIME" >> $DIR/health.log
echo "[$TIMESTAMP] Users	:	$USERS connected " >> $DIR/health.log
echo "========================================" >> $DIR/health.log

bash $DIR/cpu_check.sh
bash $DIR/ram_check.sh
bash $DIR/disk_check.sh
bash $DIR/network_check.sh

echo "========================================" >> $DIR/health.log
echo "" >> $DIR/health.log
echo "" >> $DIR/health.log
echo "" >> $DIR/health.log
