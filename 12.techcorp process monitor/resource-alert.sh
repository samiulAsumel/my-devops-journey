#!/bin/bash

##################################################
# TechCorp Resource Alert Script
# Purpose: Send alerts when critical processes are down.
# Author: samiulAsumel
##################################################

# Threshold for failed processes to trigger alert
CPU_THRESHOLD=10
MEM_THRESHOLD=15


# Get Current usage
# CPU: sum of user and system usage from top. Use LC_ALL=C for consistent decimal separators.
# Round to integer to allow simple integer comparisons.
CPU_USAGE=$(LC_ALL=C top -b -n1 | grep -E "Cpu\(s\)|Cpu" | head -1 | awk '{gsub(/,/,"."); printf "%.0f", ($2 + $4)}')
# Memory: calculate used/total and round to integer percentage
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.0f", $3/$2*100}')

echo "Current resource usage:"
echo "CPU Usage: ${CPU_USAGE}%"
echo "Memory Usage: ${MEM_USAGE}%"

# Check CPU
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
	echo "ALERT: CPU usage is above threshold! Current: ${CPU_USAGE}%, Threshold: ${CPU_THRESHOLD}%"
	echo "Top CPU consuming processes:"
	ps aux --sort=-%cpu | head -10
fi

# Check Memory
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then 
	echo "ALERT: Memory usage is above threshold! Current: ${MEM_USAGE}%, Threshold: ${MEM_THRESHOLD}%"
	echo "Top Memory consuming processes:"
	ps aux --sort=-%mem | head -10
fi

# End of Script
echo "Resource alert script completed."
