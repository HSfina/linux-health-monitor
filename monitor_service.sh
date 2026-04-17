#!/bin/bash
# Continuously runs CPU, RAM, disk, and network checks at regular intervals as a monitoring loop.

source /home/soufiane/linux-health-monitor/config.cfg
DIR=~/linux-health-monitor

echo "Health Monitor Service started at $(date)"

while true; do
    bash $DIR/monitor_check.sh
    sleep ${MONITOR_INTERVAL:-300}
done
