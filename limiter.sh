#!/bin/bash
# Dell Inspiron 5410 Long-Life Script
#  - Limits battery to 80% for longevity
#  - Switches fan mode based on AC/Battery status

BATTERY_FILE="/sys/class/power_supply/BAT0/charge_control_end_threshold"
if [ -f "$BATTERY_FILE" ]; then
    echo 80 | sudo tee $BATTERY_FILE > /dev/null
fi

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
