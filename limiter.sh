#!/bin/bash
# Dell Inspiron 5410 Long-Life Script
#  - For battery threshold management, use optimize_battery_lifespan.sh
#  - Switches fan mode based on AC/Battery status

source "$(dirname "$0")/battery_utils.sh"

BAT_PATH="/sys/class/power_supply/BAT0"

# Only sets battery thresholds
set_dynamic_battery_thresholds "$BAT_PATH"

while true; do
    STATUS=$(acpi -a | awk '{print $3}')
    if [ "$STATUS" = "on-line" ]; then
        # Cool mode when plugged in
        sudo i8kctl fan 2 2
    else
        # Optimized mode when on battery
        sudo i8kctl fan 1 1
    fi
    sleep 30
done
