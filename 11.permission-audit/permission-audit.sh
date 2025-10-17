#!/bin/bash

# TechCorp Permission Audit Tool
# Author: samiulAsumel

# This script audits file and directory permissions in a specified directory.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPORT_FILE="audit_$(date +%Y%m%d_%H%M%S).txt"

echo "===============================" | tee "$REPORT_FILE"
echo "TechCorp Permission Audit" | tee -a "$REPORT_FILE"
echo "Generated: $(date)" | tee -a "$REPORT_FILE"
echo "Server: $(hostname)" | tee -a "$REPORT_FILE"
echo "Auditor: samiulAsumel" | tee -a "$REPORT_FILE"
echo "===============================" | tee -a "$REPORT_FILE"

#1. World-Writable Files (Danger)
echo -e "\n${RED}1. World-Writable Files (Danger)${NC}" | tee -a "$REPORT_FILE"
find /home /opt /var -type f -perm -002 2>/dev/null | head -2 | tee -a "$REPORT_FILE"

COUNT=$(find /home /opt /var -type f -perm -002 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
	echo -e "${RED} Found $COUNT world-writable files!${NC}" | tee -a "$REPORT_FILE"
else
	echo -e "${GREEN} No world-writable files found.${NC}" | tee -a "$REPORT_FILE"
fi

#2. SUID Files
echo -e "\n${YELLOW}2. SUID Files (Security Check)${NC}" | tee -a "$REPORT_FILE"
find / -perm -4000 -type f 2>/dev/null | tee -a "$REPORT_FILE"
COUNT=$(find / -perm -4000 2>/dev/null | wc -l)
echo "Total: $COUNT" | tee -a "$REPORT_FILE"

#3. Files with no owner
echo -e "\n${RED}Files with No Owner (Danger)${NC}" | tee -a "$REPORT_FILE"
find /home /opt -nouser 2>/dev/null | tee -a "$REPORT_FILE"

#4. SSH Key permissions
echo -e "\n${YELLOW}SSH Key Permissions Check${NC}" | tee -a "$REPORT_FILE"
find /home -name "id_rsa" 2>/dev/null | while IFS= read -r key; do
	PERMS=$(stat -c "%a" "$key" 2>/dev/null || echo "")
	if [ "$PERMS" != "600" ]; then
		echo -e "${RED} $key: $PERMS (Should be 600)${NC}" | tee -a "$REPORT_FILE"
	else
		echo -e "${GREEN} $key: Correct permissions (600)${NC}" | tee -a "$REPORT_FILE"
	fi
done

#5. Recommendation
echo -e "\n${GREEN} Recommendations:${NC}" | tee -a "$REPORT_FILE"
cat << 'REC' | tee -a "$REPORT_FILE"

1. Fix world-writable files:
   chmod 644 filename

2. Remove unnecessary SUID bits:
   chmod u-s filename

3. Fix SSH keys:
   chmod 600 ~/.ssh/id_rsa

4. Secure config files:
   chmod 640 sensitive.conf

REC

echo -e "\n${GREEN}Audit complete. Report saved to $REPORT_FILE${NC}"

exit 0
