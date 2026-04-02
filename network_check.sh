#!/bin/bash

source ~/linux-health-monitor/config.cfg

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if ping -c 1 -W 5 8.8.8.8 > /dev/null 2>&1 || ping -c 1 -W 5 1.1.1.1 > /dev/null 2>&1; then
	echo "[$TIMESTAMP] Network Status: UP" | tee -a $LOGFILE
else
	echo "[$TIMESTAMP] Network Status: DOWN" | tee -a $LOGFILE
	echo -e "To: $EMAIL\nSubject: Network Alert - $(hostname)\n\nALERT: Internet is DOWN on $(hostname) at $TIMESTAMP" | msmtp -t
fi
