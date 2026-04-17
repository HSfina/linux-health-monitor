#!/bin/bash
# security_audit.sh - Complete system security audit

if [ -f ~/linux-health-monitor/config.cfg ]; then
	source ~/linux-health-monitor/config.cfg
else
	echo "Error: Config file not found"
	exit 1
fi

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
DATE=$(date "+%Y-%m-%d")

ROOT_USERS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
NO_PASS=$(sudo awk -F: '($2 == "" || $2 == "!" || $2 == "*") {print $1}' /etc/shadow)
if [ -z "$NO_PASS" ]; then
    NO_PASS_ACC="  ✅ All users have passwords"
else
    NO_PASS_ACC="  🚨 $NO_PASS"
fi
SUID=$(find / -perm -4000 -type f 2>/dev/null | head -5 | sed 's/^/  /')
OPEN_PORTS=$(ss -tlnp | sed '1d' | sed 's/^/  /')
A_SERVICE=$(systemctl list-units --type=service --state=active --no-pager | head -5 | sed 's/^/  /')



REPORT=$( cat <<EOF

===================================================
	SECURITY AUDIT REPORT — $DATE
===================================================


🔐 Users with root privileges (UID=0)
----------------------------------------
$ROOT_USERS


⚠️  Users without password
----------------------------------------
$NO_PASS_ACC


🔍 SUID files (top 5)
----------------------------------------
$SUID


🌐 Open ports
----------------------------------------
$OPEN_PORTS


⚙️  Active services (top 5)
----------------------------------------
$A_SERVICE


================================================
Generated : $TIMESTAMP
================================================
EOF
)

if [ -z "$EMAIL" ]; then
	echo "Error: Email is not set"
	exit 1
else
	echo -e "To: $EMAIL\nSubject: 🔐 Security Audit - $(hostname) - $DATE\n\n$REPORT" | msmtp -t
	echo "Audit report sent to $EMAIL ✅"
fi

