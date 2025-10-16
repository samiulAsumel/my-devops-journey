#!/bin/bash
# User Audit Script

# Author: samiulAsumel

echo "=== TechCorp User Audit Report ==="
echo "Current Date: $(date)"
echo ""

echo "---Human Users (UID >= 1000)---"
awk  -F: '$3 >= 1000 && $3 < 65534 {print $1, "UID:", $3, "Home:", $6}' /etc/passwd
echo ""

echo "---Sudo Users---"
if getent group wheel >/dev/null 2>&1; then
	# print wheel group members (comma-separated list from group entry)
	getent group wheel | awk -F: '{print $4}'
elif getent group sudo >/dev/null 2>&1; then
	# print sudo group members
	getent group sudo | awk -F: '{print $4}'
else
	echo "No wheel or sudo group found"
fi
echo ""

echo "---Locked Accounts---"
# Prefer reading /etc/shadow to detect locked password entries (requires root)
if sudo test -r /etc/shadow >/dev/null 2>&1; then
	sudo awk -F: '($2 ~ /^!|^\*|^!!/) {print $1}' /etc/shadow
else
	echo "/etc/shadow not readable; run as root or grant sudo to list locked accounts"
fi
echo ""

echo "---User with Password Expiry---"
awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd | while read -r user; do
    echo "$user:"
	sudo chage -l "$user" | grep "Password expires"
done

echo "User audit completed."