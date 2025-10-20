#!/bin/bash

##################################################
# TechCorp Process Manager
# Purpose: Manage and coordinate process health checks and resource alerts.
# Author: samiulAsumel
##################################################

show_menu() {
	clear
	echo "TechCorp Process Manager"
	echo "========================"
	echo "1) View all processes (ps aux)"
	echo "2) Monitor processes (top)"
	echo "3) Find processes by name"
	echo "4) Kill processes by PID"
	echo "5) Find processes using port"
	echo "6) Show top CPU consuming processes"
	echo "7) Show top Memory consuming processes"
	echo "8) Check specific service status"
	echo "9) Exit"
	echo ""

	read -p "Choose an option [1-9]: " choice
}

find_by_name() {
	read -p "Enter processes name: " pname
	echo "Searching for processes matching: $pname"
	ps aux | grep $pname | grep -v grep
	read -p "Press Enter to continue..."
}

kill_by_pid() {
	read -p "Enter PID to kill: " pid
	read -p "Force kill with -9? (y/n): " force

	if [ "$force" == "y" ]; then
		sudo kill -9 "$pid" && echo "Process $pid killed forcefully."
	else
		sudo kill "$pid" && echo "Process $pid killed gracefully."
	fi

	read -p "Press Enter to continue..."
}

find_by_port() {
	read -p "Enter port number: " port
	echo "Finding processes using port: $port"
	sudo lsof -i :$port
	read -p "Press Enter to continue..."
}

while true; do
	show_menu

	case $choice in
		1) ps aux; read -p "Press Enter to continue...";;
		2) top; read -p "Press Enter to continue...";;
		3) find_by_name;;
		4) kill_by_pid;;
		5) find_by_port;;
		6) echo "Top 10 CPU consuming processes:"; ps aux --sort=-%cpu | head -n 11; read -p "Press Enter to continue...";;
		7) echo "Top 10 Memory consuming processes:"; ps aux --sort=-%mem | head -n 11; read -p "Press Enter to continue...";;
		8) read -p "Enter service name: " sname; systemctl status $sname; read -p "Press Enter to continue...";;
		9) echo "Exiting TechCorp Process Manager. Goodbye!"; exit 0;;
		*) echo "Invalid option. Please try again."; read -p "Press Enter to continue...";;
	esac
done