# Linux Health Monitor
Automated system health monitoring scripts for Linux servers.
Built by **Soufiane Hamssassia** — IT Support & Network Admin

---

## What it does

- Monitors **CPU**, **RAM**, and **Disk** usage every hour
- Logs all results with timestamps to `health.log`
- Sends **email alerts** via Gmail SMTP when thresholds are exceeded

---

##  Project Structure
```
linux-health-monitor/
├── health_monitor.sh   # Main script (calls all checks)
├── cpu_check.sh        # CPU usage monitor
├── ram_check.sh        # RAM usage monitor
├── disk_check.sh       # Disk usage monitor
├── health.log          # Sample log output (auto-generated)
└── README.md
```

## Setup

### 1. Clone the repo
```bash
git clone git@github.com:YOURUSERNAME/linux-health-monitor.git
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
password       ***Secret***

account default : gmail
```
```bash
chmod 600 ~/.msmtprc
```

### 3. Set up cron job
```bash
crontab -e
```
	```
	0 * * * * /bin/bash /home/soufiane/linux-health-monitor/health_monitor.sh
	```

---

## Sample Log Output
```
========================================
[2024-01-15 14:00:01] Starting health check...
========================================
[2024-01-15 14:00:01] CPU Usage: 12%
[2024-01-15 14:00:01] RAM Usage: 45.20%
[2024-01-15 14:00:01] Disk Usage: 34%
```

---

## Configuration

| Parameter | Default 	| Description 		|
|-----------|-----------|-----------------------|
| THRESHOLD | 80% 	| Alert trigger level 	|
| LOG_FILE  | health.log| Log file location 	|
| Cron 	    | Every hour| Check frequency 	|

---

## Skills Demonstrated

- Bash scripting (variables, conditions, functions)
- Linux system administration
- Cron job scheduling
- SMTP email configuration
- Git & GitHub version control
