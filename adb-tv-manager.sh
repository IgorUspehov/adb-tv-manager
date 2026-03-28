#!/bin/bash

# =============================================
# ADB TV Manager — Lite Version
# Author: Ihor Kriazhev (IgorUspehov)
# GitHub: https://github.com/IgorUspehov
# Full version: fiverr.com/ihor_uspehov
# =============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

LOG_FILE="$HOME/adb-tv-manager.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_devices() {
    adb devices | grep -v "List of devices" | grep "device$" | awk '{print $1}'
}

check_internet() {
    adb -s "$1" shell ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "Online" || echo "Offline"
}

get_device_info() {
    MODEL=$(adb -s "$1" shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    ANDROID=$(adb -s "$1" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    echo "$MODEL (Android $ANDROID)"
}

echo -e "${CYAN}"
echo "=============================="
echo "      ADB TV Manager"
echo "      Lite Version"
echo "=============================="
echo -e "${NC}"

log "=== SESSION START ==="

DEVICES=$(get_devices)

if [ -z "$DEVICES" ]; then
    echo -e "${RED}No ADB devices found.${NC}"
    echo "Make sure devices are connected and ADB is enabled."
    log "No devices found"
    exit 1
fi

COUNT=$(echo "$DEVICES" | wc -l)
echo -e "${YELLOW}Found: $COUNT device(s)${NC}"
echo ""

for DEV in $DEVICES; do
    INFO=$(get_device_info "$DEV")
    STATUS=$(check_internet "$DEV")

    if [ "$STATUS" = "Online" ]; then
        COLOR=$GREEN
    else
        COLOR=$RED
    fi

    echo -e "  Device: ${CYAN}$DEV${NC}"
    echo -e "  Model:  $INFO"
    echo -e "  Status: ${COLOR}$STATUS${NC}"
    echo ""

    log "Device: $DEV | $INFO | $STATUS"
done

echo -e "${CYAN}=============================="
echo -e "  Log saved: $LOG_FILE"
echo -e "==============================${NC}"
echo ""
echo -e "Full version with advanced features:"
echo -e "→ fiverr.com/ihor_uspehov"
