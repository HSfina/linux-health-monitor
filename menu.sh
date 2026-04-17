#!/bin/bash
# Provides an interactive menu to run health checks, view logs, test alerts, rotate logs, or exit.

DIR=~/linux-health-monitor
source $DIR/config.cfg

while true; do
    echo ""
    echo ""
    echo ""
    echo "|_________________________________________________________|"
    echo "|------------------ Health Monitor Menu ------------------|"
    echo "|1- Run health check now                                  |"
    echo "|2- View last log                                         |"
    echo "|3- Test email alert                                      |"
    echo "|4- Rotate logs                                           |"
    echo "|5- Exit                                                  |"
    echo "|_________________________________________________________|"

    read -p "Choose option [1-5]: " choice

    case $choice in

        1) bash $DIR/health_monitor.sh ;;
        2) cat $DIR/health.log | tail -14 ;;
        3) echo -e "To: $EMAIL\nSubject: Test Alert\n\nTest alert from menu" | msmtp -t && echo "THE EMAIL HAS BEEN SENT SUCCESSFULLY" ;;
        4) bash $DIR/rotate_log.sh ;;
        5) echo "GOODBYE, SIR!" && exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
