#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT0"

if [ ! -d "$BAT_PATH" ]; then
  echo "Battery information not found."
  exit 1
fi

energy_full=$(cat $BAT_PATH/energy_full)
energy_full_design=$(cat $BAT_PATH/energy_full_design)

if [ -z "$energy_full" ] || [ -z "$energy_full_design" ]; then
  echo "Could not read battery capacity info."
  exit 1
fi

wear_level=$(echo "scale=2; (1 - $energy_full / $energy_full_design) * 100" | bc)

echo "Battery Wear Level: $wear_level%"
