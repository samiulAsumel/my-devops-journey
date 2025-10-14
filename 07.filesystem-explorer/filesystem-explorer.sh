#!/bin/bash

# Filesystem Explorer Script
# Purpose: Document system filesystem structure and usage

# Author: samiulAsumel

echo "Filesystem Explorer Script Started"
echo "----------------------------------"
echo ""

echo "Generated on: $(date)"
echo ""

echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
echo ""

# System information
echo "System Information:"
echo "-------------------"
echo "Operation System: $(uname -o)"
echo "Kernel Version: $(uname -r)"
echo "Hostname: $(hostname)"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
echo ""

# Root Directory Structure
echo "Root Directory Structure:"
echo "-------------------------"
ls -l /
echo ""

# Disk Usage
echo "Disk Usage:"
echo "-----------"
df -h
echo ""

# Important Directories Size
echo "Important Directories Size:"
echo "--------------------------"
echo "/var Size: $(du -sh /var | awk '{print $1}')"
echo "/home Size: $(du -sh /home | awk '{print $1}')"
echo "/usr Size: $(du -sh /usr | awk '{print $1}')"
echo "/etc Size: $(du -sh /etc | awk '{print $1}')"
echo ""

# User Home Directory
echo "User Home Directory Structure:"
echo "------------------------------"
ls -lah ~
echo ""

echo "Filesystem Explorer Script Completed"
echo "--------------------------------"