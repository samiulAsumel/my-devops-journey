#!/bin/bash

# TechCorp User Onboarding Script
# Purpose: Automate new user creation

# Author: samiulAsumel

# ==============================

# Color code for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}" 
   echo "Usage: sudo ./user-onboarding.sh"
   exit 1
fi

echo "=================================="
echo " TechCorp User Onboarding Script"
echo "=================================="
echo ""

# Input user details
read -p "Enter the new username: " username

echo ""

# Validate username is not empty
if [[ -z "${username// }" ]]; then
	echo -e "${RED}Error: Username cannot be empty.${NC}"
	exit 1
fi

# Check if user already exists
if id "$username" &>/dev/null; then
	echo -e "${RED}Error: User '$username' already exists!${NC}"
	exit 1
fi

# Input: Full Name
read -p "Enter the full name: " fullname

# Input: Department
echo "Select Department:"
echo "1) Development"
echo "2) QA"
echo "3) DevOps"
echo "4) HR"
echo "5) Sales"
echo "6) Marketing"
echo "7) Finance"
echo "8) Support"
echo "9) IT"
echo "10) Admin"
read -p "Enter choice (1-10): " dept_choice

case $dept_choice in
	1) department="Development" ;;
	2) department="QA" ;;
	3) department="DevOps" ;;
	4) department="HR" ;;
	5) department="Sales" ;;
	6) department="Marketing" ;;
	7) department="Finance" ;;
	8) department="Support" ;;
	9) department="IT" ;;
	10) department="Admin" ;;
	*) echo -e "${RED}Invalid choice!${NC}"; exit 1 ;;
esac

# Input: Sudo Access
read -p "Grant sudo access? (y/n): " sudo_access

echo ""
echo "=================================="
echo "Creating user with following details:"
echo "Username: $username"
echo "Full Name: $fullname"
echo "Department: $department"
echo "Sudo Access: $sudo_access"
echo "=================================="
read -p "Proceed? (y/n): " confirm

if [[ "${confirm,,}" != "y" ]]; then
	echo "Aborting user creation."
	exit 1
fi

# Create the user
echo -e "${YELLOW}Creating user...${NC}"
useradd -m -s /bin/bash -c "$fullname" "$username"

if [[ $? -eq 0 ]]; then
	echo -e "${GREEN}User '$username' created successfully.${NC}"
else
	echo -e "${RED}Failed to create user '$username'.${NC}"
	exit 1
fi

# Set password
echo -e "${YELLOW}Setting password for user...${NC}"
passwd "$username"
if [[ $? -ne 0 ]]; then
	echo -e "${RED}Failed to set password for '$username'.${NC}"
	exit 1
fi

# Create group if doesn't exist
if ! getent group "$department" > /dev/null 2>&1; then
	echo -e "${YELLOW}Creating group '$department'...${NC}"
	groupadd "$department"
fi

# Add user to department group
echo -e "${YELLOW}Adding user to group '$department'...${NC}"
usermod -aG "$department" "$username"

# Grant sudo access if requested
if [[ "${sudo_access,,}" == "y" ]]; then
	echo -e "${YELLOW}Granting sudo access to user...${NC}"
	echo "$username ALL=(ALL) ALL" >> /etc/sudoers.d/"$username"
	chmod 440 /etc/sudoers.d/"$username"
	echo -e "${GREEN}Sudo access granted.${NC}"
fi

# Create user project directory
user_project_dir="/home/$username/projects"
mkdir -p "$user_project_dir"/{bin,configs,docs,scripts,logs,backups}
chown -R "$username":"$username" "/home/$username/projects"
echo -e "${GREEN}Project directory structure created at '$user_project_dir'.${NC}"

echo -e "${GREEN}User onboarding complete!${NC}"
echo "User Details:"
echo "Username: $username"
echo "Full Name: $fullname"
echo "Department: $department"
echo "Home Directory: /home/$username"
echo "Project Directory: $user_project_dir"
if [[ "${sudo_access,,}" == "y" ]]; then
	echo "Sudo Access: Granted"
else
	echo "Sudo Access: Not Granted"
fi
echo ""
echo "Please provide the user with their username and password."
echo "=================================="
echo " TechCorp User Onboarding Script"
echo "=================================="
echo ""
exit 0
