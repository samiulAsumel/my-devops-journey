#!/bin/bash

# Advanced System Monitor Script
# Author: Samiul A Sumel
# Day 3 of My DevOps Journey: Process Management

# Configaration
LOG_DIR="logs"
REPORT_DIR="reports"
CURRENT_USER=$(whoami)
REPORT_FILE="$REPORT_DIR/system-report-$(date +%Y%m%d-%H%M%S).txt"

# Create Directories
mkdir -p $LOG_DIR
mkdir -p $REPORT_DIR

# Function to log Actions
log_action() {
	echo "$(date): $1" >> "$LOG_DIR/system-monitor.log"
}

# Function to monitor processes
monitor_processes() {
	echo "=== Process Analysis ==="

	echo "1. Top 5 CPU Processes: $(ps aux --sort=-%cpu | head -n 6)"
	echo ""

	echo "2. Top 5 Memory Processes: $(ps aux --sort=-%mem | head -n 6)"
	echo ""

	echo "3. User's Process count: $(ps -u $CURRENT_USER | wc -l)"
	echo ""

	echo "4. Total system processes: $(ps aux | wc -l)"
	echo ""

}

#  Function to monitor system resources
monitor_resources() {
	echo "===System Resource Usage ==="

	echo "1. Memory usages: $(free -h)"
	echo ""

	echo "2. Disk Usage: $(df -h | grep -v tmpfs | grep -v udev)"
	echo ""

	echo "3. Load Average: $(uptime)"
	echo ""
}

# Function to monitor services
monitor_services() {
	echo "=== Services Status ==="

	echo "1. SSH Services: $(systemctl 0s-active sshd)"
	echo ""

	echo "2. Network Services: $(ss -tuln | head -n 10)"
	echo ""

}

# Main Monitoring Function
main_monitor() {
	echo "=== System Monitoring Report ==="
	echo "Time: $(date)"
	echo "User: $CURRENT_USER"
	echo "==============================="
	echo ""

	monitor_processes
	monitor_resources
	monitor_services

	log_action "System monitoring completed."
}

# Generate Report
main_monitor > $REPORT_FILE
echo "Report generated: $REPORT_FILE"
echo "Check $LOG_DIR/system-monitor.log for logs."
echo "Monitoring completed."