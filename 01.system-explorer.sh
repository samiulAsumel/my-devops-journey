#!/bin/bash

# File: system_explorer.sh
# Description: A simple system explorer script to navigate and manage files and directories.

# My DevOps Script - Syetem Explorer
# Author: Samiul A Sumel
# Day 1 Project - System Information Tool

# ==============================================================
# Version: 1.0
# Date: 2024-06-10
# ==============================================================

echo ""
echo "SYSTEM EXPLORER REPORT"
echo "======================"
echo "Report Time: $(date)"
echo "User: $(whoami)"
echo ""

# 1. System Basic Info
echo "BASIC SYSTEM INFO:"
echo "------------------"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo ""

# 2. Disc Space
echo "DISC USAGE:"
echo "-----------"
echo "Disc Usage Summary: $(df -h | head -n 9)"
echo ""

# 3. Memory Info:
echo "MEMORY USAGE:"
echo "-------------"
echo "Memory Summary: $(free -h)"
echo ""

# 4. Current Directory Files
echo "CURRENT DIRECTORY FILES:"
echo "------------------------"
echo "Current Directory: $(pwd)"
echo "Files: $(ls -lh | wc -l)"
echo ""

# 5 Network Info
echo "NETWORK INFO:"
echo "-------------"
echo "IP Address: $(ip a | grep 'inet' | grep -v '127.0.0.1' | awk '{print $2}')"
echo ""

echo "System Explorer Script Completed."
echo "======================"
echo ""