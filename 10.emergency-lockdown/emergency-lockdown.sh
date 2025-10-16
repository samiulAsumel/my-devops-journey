#!/bin/bash
# Emergency Lockdown Script
# This script is designed to quickly secure a server in case of a security breach.

echo " Emergency Lockdown Initiated"
echo "============================"

# Safe Users (Don't lock these)

SAFE_USERS=("root" "admin")

# Lock All other human users
for user in $(cut -f1 -d: /etc/passwd); do
    if [[ ! " ${SAFE_USERS[@]} " =~ " ${user} " ]]; then
		echo "Locking user: $user"
		usermod -L $user
	fi
done

echo "$(date): Emergency lockdown executed by $(whoami)" >> /var/log/emergency-lockdown.log

echo "Lockdown complete. All non-safe users have been locked."