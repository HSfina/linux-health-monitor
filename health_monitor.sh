#!/bin/bash
# health_monitor.sh - Main system health monitor
# Author: Soufiane Hamssassia
# Description: Checks CPU, RAM, and Disk usage and logs results

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================" >> $DIR/health.log
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting health check..." >> $DIR/health.log
echo "========================================" >> $DIR/health.log

bash $DIR/cpu_check.sh
bash $DIR/ram_check.sh
bash $DIR/disk_check.sh

echo "" >> $DIR/health.log
