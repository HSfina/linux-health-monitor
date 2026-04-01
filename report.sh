#!/bin/bash



source ~/linux-health-monitor/config.cfg

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
DATE=$(date "+%Y-%m-%d")
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
USERS=$(who | wc -l)


CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
TOP_CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu |head -4 | tail -3 | awk '$2 != "ps"')
TOTAL=$(free | grep Mem | awk '{print $2}')
USED=$(free | grep Mem | awk '{print $3}')
RAM=$(echo "scale=2; $USED/$TOTAL*100" | bc)
DISK=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)
PARTITION_DISK=$(df -h | awk 'NR==1 || /^\/dev/' | column -t)
SYS_ERROR=$(journalctl -p err -n 3 --no-pager | sed G)


if ping -c 1 -W 5 8.8.8.8 > /dev/null 2>&1 || ping -c 1 -W 5 1.1.1.1 > /dev/null 2>&1; then
    NETWORK="UP"
else
    NETWORK="DOWN"
fi


REPORT="
=======================================
   DAILY HEALTH REPORT — $DATE
=======================================

Server   : 	$HOSTNAME
Uptime   : 	$UPTIME
Users    : 	$USERS connected

----------------------------------------

CPU Usage	:	${CPU}%   $([ $(echo "$CPU > $CPU_THRESHOLD" | bc -l) -eq 1 ] && echo 'ALERT' || echo 'OK')
RAM Usage	:	${RAM}%   $([ $(echo "$RAM > $RAM_THRESHOLD" | bc -l) -eq 1 ] && echo 'ALERT' || echo 'OK')
Disk Usage	:	${DISK}%  $([ $(echo "$DISK > $DISK_THRESHOLD" | bc -l) -eq 1 ] && echo 'ALERT' || echo 'OK')
Network		:	$NETWORK

----------------------------------------

Top CPU Processes:

$TOP_CPU

----------------------------------------

Disk Partition:

$PARTITION_DISK

----------------------------------------

Last Errors Recorded:

$SYS_ERROR

----------------------------------------

Thresholds : CPU=${CPU_THRESHOLD}% | RAM=${RAM_THRESHOLD}% | Disk=${DISK_THRESHOLD}%
Generated  : $TIMESTAMP

=======================================
"

echo "$REPORT" | tee -a $LOGFILE

echo -e "To: $EMAIL\nSubject: Daily Report - $HOSTNAME - $DATE\n$REPORT" | msmtp -t
echo "Report sent to $EMAIL"
