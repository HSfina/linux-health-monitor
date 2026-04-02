#!/bin/bash

source /home/soufiane/linux-health-monitor/config.cfg
DIR=~/linux-health-monitor

echo "Health Monitor Service started at $(date)"

while true; do
    bash $DIR/cpu_check.sh
    bash $DIR/ram_check.sh
    bash $DIR/disk_check.sh
    bash $DIR/network_check.sh
    sleep ${MONITOR_INTERVAL:-300}
done
