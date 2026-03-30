# Linux Health Monitor

Automated system health monitoring scripts for Linux servers.
Built by **Soufiane Hamssassia** — IT Support & Network Admin

---

## What it does

- Monitors **CPU**, **RAM**, **Disk**, and **Network** status
- Logs all results with timestamps to `health.log`
- Sends **Email alerts** via Gmail SMTP when thresholds are exceeded
- Rotates logs daily and cleans archives older than 7 days
- Includes an interactive menu for manual operations

---

## Project Structure
```
linux-health-monitor/
├── config.cfg          # Centralized configuration (thresholds, email)
├── health_monitor.sh   # Main script (calls all checks)
├── cpu_check.sh        # CPU usage monitor
├── ram_check.sh        # RAM usage monitor
├── disk_check.sh       # Disk usage monitor
├── network_check.sh    # Network connectivity monitor
├── rotate_log.sh       # Daily log rotation and cleanup
├── menu.sh             # Interactive menu
├── screenshots/        # Sample output screenshots
└── README.md
```

## Setup

### 1. Clone the repo
```bash
git clone git@github.com:HSfina/linux-health-monitor.git
cd linux-health-monitor
chmod +x *.sh
```

### 2. Configure email alerts
```bash
sudo apt install msmtp msmtp-mta -y
```

Create `~/.msmtprc` :
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
password       ****SECRET****

account default : gmail
```
```bash
chmod 600 ~/.msmtprc
```

### 3. Edit config.cfg
```bash
nano config.cfg
```
```
CPU_THRESHOLD=85
RAM_THRESHOLD=75
DISK_THRESHOLD=90
EMAIL="hamssassia9@gmail.com"
LOGFILE=~/linux-health-monitor/health.log
```

### 4. Set up cron jobs
```bash
crontab -e
```
```
# Health check every hour
0 * * * * /bin/bash /home/YOUR_USERNAME/linux-health-monitor/health_monitor.sh

# Log rotation every day at midnight
0 0 * * * /bin/bash /home/YOUR_USERNAME/linux-health-monitor/rotate_log.sh
```

---

## Systemd Service (Alternative to Cron)

Install and enable the service:
```bash
sudo cp health_monitor.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable health_monitor
sudo systemctl start health_monitor
```

Manage the service:
```bash
sudo systemctl status health_monitor   
sudo systemctl stop health-monitor     
sudo systemctl restart health-monitor  
journalctl -u health-monitor -f
```

---

## Sample Log Output
```
========================================
[2026-03-29 08:00:01] Starting health check...
[2026-03-29 08:00:01] Server  : health-monitor
[2026-03-29 08:00:01] Uptime  : up 2 hours, 15 minutes
[2026-03-29 08:00:01] Users   : 1 connected
========================================
[2026-03-29 08:00:01] CPU Usage: 12%
[2026-03-29 08:00:01] RAM Usage: 45.20%
[2026-03-29 08:00:01] Disk Usage: 34%
[2026-03-29 08:00:02] Network Status: UP
========================================
```

---

## Configuration

| Parameter | Default | Description |
|---|---|---|
| CPU_THRESHOLD | 85% | CPU alert trigger |
| RAM_THRESHOLD | 75% | RAM alert trigger |
| DISK_THRESHOLD | 90% | Disk alert trigger |
| EMAIL | your@gmail.com | Alert recipient |
| Cron health | Every hour | Check frequency |
| Cron rotate | Every midnight | Log rotation |

---

## Skills Demonstrated

- Bash scripting (variables, conditions, loops, functions)
- Linux file permissions and user management
- Cron job scheduling
- Systemd service configuration
- SMTP email setup with msmtp
- Git & GitHub version control

