#!/bin/bash

# System Information Script
# Author: SamiulASumel

echo "==============================="
echo "TechCorp Server Info"
echo "==============================="
echo ""

echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
echo "Home Directory: $HOME"
echo "Shell: $SHELL"
echo ""

echo "=== Directory Contents ==="
ls -lh

echo ""
echo "=============================="
echo "Script Completed Successfully!"
echo "=============================="