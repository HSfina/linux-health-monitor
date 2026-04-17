# Linux Health Monitor
Automated Monitoring & Alerting System for Linux Servers
Built by **Soufiane Hamssassia** — IT Support & Network Admin

---

## Features

- Real-time system monitoring (`CPU`, `RAM`, `Disk`, `Network`)
- Email alerts via Gmail SMTP (`msmtp`)
- Daily automated health reports
- Security auditing and log analysis
- Log rotation with 7-day cleanup
- systemd service & timer automation
- Interactive CLI menu and status dashboard
- User and group management with notifications

---

## What it does

- Monitors system health every 5 minutes using a systemd service
- Logs results with timestamps to `health.log`
- Sends alerts when thresholds are exceeded
- Generates a daily report sent via email
- Performs on-demand security audits
- Automatically rotates and cleans logs

---

## Project Structure
```
linux-health-monitor/
├── config.cfg
├── health_monitor.sh
├── monitor_service.sh
├── health_monitor.service
├── health_report.service
├── health_report.timer
├── report.sh
├── log_analyzer.sh
├── security_audit.sh
├── status.sh
├── menu.sh
├── user_manager.sh
├── rotate_log.sh
├── cpu_check.sh
├── ram_check.sh
├── disk_check.sh
├── network_check.sh
├── screenshots/
└── README.md
```

---

## Setup

### 1. Clone the repository

```bash
git clone git@github.com:HSfina/linux-health-monitor.git
cd linux-health-monitor
chmod +x *.sh
```

### 2. Configure email alerts
```bash
sudo apt install msmtp msmtp-mta -y
```
Create ```~/.msmtprc```:
```
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           hamssassia9@gmail.com
user           hamssassia9@gmail.com
password       **************

account default : gmail
```
```bash
chmod 600 ~/.msmtprc
```

---

### 3. Configure thresholds

Edit ```config.cfg```:
```
CPU_THRESHOLD=85
RAM_THRESHOLD=75
DISK_THRESHOLD=90
EMAIL="hamssassia9@gmail.com"
LOGFILE=~/linux-health-monitor/health.log
```

---

 ### 4. Set up cron jobs
```bash
crontab -e
```
```
`0 * * * *  /bin/bash /home/soufiane/linux-health-monitor/health_monitor.sh
0 0 * * *  /bin/bash /home/soufiane/linux-health-monitor/rotate_log.sh`
```

---

## Systemd Service

```bash
sudo cp health_monitor.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable health_monitor
sudo systemctl start health_monitor`
```

```bash
sudo systemctl status health_monitor    # Check status
sudo systemctl stop health_monitor      # Stop
sudo systemctl restart health_monitor   # Restart
journalctl -u health_monitor -f         # Live logs`
```

---

## Daily Report Timer

```bash
sudo cp health_report.service health_report.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now health_report.timer
sudo systemctl list-timers`
```

---

## Screenshots

### System Status Dashboard
![Status Dashboard](screenshots/status_dashboard.png)

### Health Monitor Log
![Health Log](screenshots/health_log.png)

### Daily Report
![Daily Report](screenshots/daily_report.png)

### Systemd Service Status
![Service Status](screenshots/service_status.png)

---

## Configuration

| Parameter | Default | Description |
|---|---|---|
| CPU_THRESHOLD | 85% | CPU alert trigger |
| RAM_THRESHOLD | 75% | RAM alert trigger |
| DISK_THRESHOLD | 90% | Disk alert trigger |
| EMAIL | hamssassia9@gmail.com | Alert recipient |
| Cron health | Every hour | Check frequency |
| Cron rotate | Every midnight | Log rotation |
| Service interval | 5 minutes | Systemd check frequency |

---

## Skills Demonstrated

- Bash scripting (variables, conditions, loops, functions)
- Linux system administration (users, groups, permissions, ACL)
- Systemd service and timer configuration
- Cron job scheduling
- SMTP email configuration (msmtp/Gmail)
- Log analysis and security auditing
- Git & GitHub version control
- Technical documentation
