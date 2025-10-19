#!/bin/bash

##################################################
# TechCorp Process Health Monitor
# Purpose: Monitor critical processes and log their status.
# Author: samiulAsumel
##################################################

# color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
LOG_FILE="../logs/process-monitor-$(date +%F).log"
REPORT_FILE="../reports/health-report-$(date +%Y-%m-%d_%H%M%S).txt"

# List of critical processes to monitor
CRITICAL_PROCESSES=(
	"nginx"
	"sshd"
	"crond"
	"systemd"
)

# Function: Log messages
log_message() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function: Check if process is running
check_process() {
	local process_name=$1

	if pgrep -x "$process_name" > /dev/null; then 
		echo -e "${GREEN} ${NC} $process_name is running."
		log_message "SUCCESS: $process_name is running."
		return 0
	else
		echo -e "${RED} ${NC} $process_name is not running."
		log_message "ALERT: $process_name is not running."
		return 1
	fi
}

# Function: Get process details
get_process_details() {
	local process_name=$1

	echo -e "${YELLOW}Fetching details for $process_name...${NC}"
	ps aux | grep "$process_name" | grep -v grep | head -10
	echo ""
}

# Function: system resource summary
show_system_resources() {
	echo -e "${YELLOW}Fetching system resource summary...${NC}"
	echo "----- CPU Usage -----"
	top -b -n1 | head -10
	echo ""

	echo "----- Memory Usage -----"
	free -h | awk 'NR==1 || NR==2'
	echo ""

	echo "----- Top Memory Consuming Processes -----"
	ps aux --sort=-%mem | head -10
	echo ""

	echo "----- Top CPU Consuming Processes -----"
	ps aux --sort=-%cpu | head -10
	echo ""
}

# Function: Check zombie processes
check_zombies() {
	local zombie_count=$(ps aux | awk '$8=="Z" {print $0}' | wc -l)

	if [ $zombie_count -gt 0 ]; then
		echo -e "${RED}Warning: $zombie_count zombie processes found.${NC}"
		ps aux | awk '$8=="Z" {print $0}'
		log_message "ALERT: $zombie_count zombie processes detected."
	else
		echo -e "${GREEN}No zombie processes found.${NC}"
		log_message "SUCCESS: No zombie processes detected."
	fi
}

# Main execution
main () {
	echo "=========================================="
	echo " TechCorp Process Health Monitor"
	echo "=========================================="
	echo "$(date '+%Y-%m-%d %H:%M:%S')"
	echo ""

	log_message "Starting process health check..."

	# Check critical processes
	echo -e "${YELLOW}Checking critical processes...${NC}"
	failed_count=0

	for process in "${CRITICAL_PROCESSES[@]}"; do
		check_process "$process"
		if [ $? -ne 0 ]; then
			failed_count=$((failed_count + 1))
			get_process_details "$process"
		fi
	done

	# Check for zombie processes
	check_zombies

	# Show system resource summary
	show_system_resources

	#Final summary
	echo -e "${YELLOW}Process Health Check Summary:${NC}"
	if [ $failed_count -eq 0 ]; then
		echo -e "${GREEN}All critical processes are running smoothly.${NC}"
		log_message "SUCCESS: All critical processes are running smoothly."
	else
		echo -e "${RED}$failed_count critical processes are not running.${NC}"
		log_message "ALERT: $failed_count critical processes are not running."
	fi

	# Save Report
	{
		echo "TechCorp Process Health Report"
		echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
		echo "Hostname: $(hostname)"
		echo "Failed Processes: $failed_count"
		echo "=========================================="
		ps aux | grep -E "$(IFS='|'; echo "${CRITICAL_PROCESSES[*]}")" | grep -v grep
		echo ""
	} > "$REPORT_FILE"

	echo "Report saved: $REPORT_FILE"
	echo "Check $LOG_FILE for logs."
	echo "Process health check completed."
}

main