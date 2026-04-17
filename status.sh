#!/bin/bash

# Displays a system health dashboard with service status, CPU, RAM, disk, and network usage
#
#
#

source ~/linux-health-monitor/config.cfg

SERVICE=$(systemctl is-active health_monitor.service)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d'.' -f1)
TOTAL=$(free | grep Mem | awk '{print $2}')
USED=$(free | grep Mem | awk '{print $3}')
RAM=$(echo "scale=2; $USED/$TOTAL*100" | bc | cut -d'.' -f1)
DISK=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1 | cut -d'.' -f1)
LAST_LOG=$(tail -1 ~/linux-health-monitor/service.log | awk '{print $1, $2}')

if [ $SERVICE == "inactive" ]; then
	SERVICE_STATS="❌ Stopped"
else
	SERVICE_STATS="✅ Running"
fi


if ping -c 1 -W 5 8.8.8.8 > /dev/null 2>&1 || ping -c 1 -W 5 1.1.1.1 > /dev/null 2>&1; then
    NETWORK="✅ UP"
else
    NETWORK="❌ DOWN"
fi


REPORT="
========================================
	SYSTEM STATUS DASHBOARD
========================================
Service	is	:	$SERVICE_STATS
CPU Usage       :       $([ $(echo "$CPU > $CPU_THRESHOLD" | bc -l) -eq 1 ] && echo '🚨' || echo '✅') ${CPU}%
RAM Usage       :       $([ $(echo "$RAM > $RAM_THRESHOLD" | bc -l) -eq 1 ] && echo '🚨' || echo '✅') ${RAM}%
Disk Usage      :	$([ $(echo "$DISK > $DISK_THRESHOLD" | bc -l) -eq 1 ] && echo '🚨' || echo '✅') ${DISK}%
Network is 	:	$NETWORK
Last Log at	:	$LAST_LOG
========================================
"


echo "$REPORT" | tee -a $LOGFILE
