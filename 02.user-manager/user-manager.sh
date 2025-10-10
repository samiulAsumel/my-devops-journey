#!/bin/bash

#==============================================================
# Title: User Manager Script
# Description: This script manages user accounts on a Linux system.
# DevOps Journey Series: User Management
# Author: Samiul A Sumel
#==============================================================

LOG_FILE="logs/user-management- $(date +'%Y-%m-%d').log"
CONFIG_FILE="config/user-management.conf"

# Create necessary files
mkdir -p logs config users-data
touch "$CONFIG_FILE"

echo ""
echo "User management system"
echo "======================"
echo "Time: $(date +'%Y-%m-%d %H:%M:%S')"
echo "Current User: $(whoami)"
echo ""

# Function to log actions
log_action() {
	echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 1. Current System Users:
echo "Current System Users:"
echo "---------------------"
echo "Total Users: $(cat /etc/passwd | wc -l)"
echo "Recent Users: $(tail -n 5 /etc/passwd | cut -d: -f1,3,6)"
echo ""

# 2. Display Current System User
echo "Current User Details:"
echo "---------------------"
echo "Username: $(whoami)"
echo "UserID: $(id -u)"
echo "GroupID: $(id -g)"
echo "Groups: $(groups)"
echo "Home Directory: $HOME"
echo ""

# 3. Check User Directory Permissions
echo "Permission Analysis:"
echo "----------------------"
echo "Home Directory: $(ls -ld "$HOME")"
echo ""

#!/bin/bash

#==============================================================
# Title: User Manager Script
# Description: This script manages user accounts on a Linux system.
# DevOps Journey Series: User Management
# Author: Samiul A Sumel
#==============================================================

LOG_FILE="logs/user-management-$(date +'%Y-%m-%d').log"
CONFIG_FILE="config/user-management.conf"

# Create necessary files
mkdir -p logs config users-data users-data/test-permissions
touch "$CONFIG_FILE"

echo ""
echo "User management system"
echo "======================"
echo "Time: $(date +'%Y-%m-%d %H:%M:%S')"
echo "Current User: $(whoami)"
echo ""

# Function to log actions
log_action() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 1. Current System Users:
echo "Current System Users:"
echo "---------------------"
echo "Total Users: $(wc -l < /etc/passwd)"
echo "Recent Users:"
tail -n 5 /etc/passwd | cut -d: -f1,3,6
echo ""

# 2. Display Current System User
echo "Current User Details:"
echo "---------------------"
echo "Username: $(whoami)"
echo "UserID: $(id -u)"
echo "GroupID: $(id -g)"
echo "Groups: $(groups)"
echo "Home Directory: $HOME"
echo ""

# 3. Check User Directory Permissions
echo "Permission Analysis:"
echo "----------------------"
echo "Home Directory: $(ls -ld "$HOME")"
echo ""

echo "Current Project Directory:"
echo "--------------------------"
echo "Project Directory: $(ls -ld "$(pwd)")"
echo ""

# 4. Create Test Files with Different Permissions
echo "Creating Test Environment:"
echo "-------------------------"
mkdir -p users-data/test-permissions
echo "Creating Directories: users-data/test-permissions"
echo "Navigate To Directories: $(cd users-data/test-permissions && pwd)"

# Creating file with different permissions (inside test dir)
touch users-data/test-permissions/admin-file.txt users-data/test-permissions/manager-file.txt users-data/test-permissions/employee-file.txt users-data/test-permissions/public-file.txt
chmod 700 users-data/test-permissions/admin-file.txt   # Only owner
chmod 750 users-data/test-permissions/manager-file.txt # Owner and group read/execute
chmod 640 users-data/test-permissions/employee-file.txt# Owner and group read/write
chmod 644 users-data/test-permissions/public-file.txt  # Everyone read

echo "Test File Permissions:"
echo "----------------------"
ls -ld users-data/test-permissions/admin-file.txt users-data/test-permissions/manager-file.txt users-data/test-permissions/employee-file.txt users-data/test-permissions/public-file.txt
echo ""

# Creating file content
echo "Admin Confidential Data" > users-data/test-permissions/admin-file.txt
echo "Manager Sensitive Data" > users-data/test-permissions/manager-file.txt
echo "Employee Internal Data" > users-data/test-permissions/employee-file.txt
echo "Public Information" > users-data/test-permissions/public-file.txt
echo ""

# 5. System health check
echo "System Health Check:"
echo "---------------------"
echo "Disk space for Home:"
df -h "$HOME" | awk 'NR==1 || NR==2'

echo ""

echo "User Management Report Complete:"
echo "Log File: $LOG_FILE"
log_action "User management report generated successfully."
echo "=============================="
echo ""
# End of Script