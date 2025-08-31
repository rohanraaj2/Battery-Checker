# Battery Checker

>This repository provides Bash scripts to help monitor and manage your laptop battery health on Linux systems.

## Table of Contents
 - [Wear Level Checker](#wear-level-checker)
 - [Battery Notifier](#battery-notifier)
 - [Battery Limiter](#battery-limiter)
 - [Battery Lifespan Optimizer](#battery-lifespan-optimizer)
 - [Requirements](#requirements)
 - [Troubleshooting](#troubleshooting)
 - [License](#license)

---

## Wear Level Checker (`wear_level.sh`)
Checks the wear level of your battery, indicating the percentage of capacity lost compared to its original design.

**How it works:**
Reads battery info from `/sys/class/power_supply/BAT0` and calculates:
```
Wear Level (%) = (1 - Current Full Capacity / Design Full Capacity) * 100
```

**Usage:**
```bash
chmod +x wear_level.sh
./wear_level.sh
```
Output example:
```
Battery Wear Level: 7.25%
```

---

## Battery Notifier (`notifier.sh`)
Sends a desktop notification and sound alert when the battery is fully charged (80%).

**How it works:**
Checks battery percentage and status, then uses `notify-send` and `paplay` for alerts.

**Usage:**
```bash
chmod +x notifier.sh
./notifier.sh
```
You may want to run this script periodically (e.g., via cron or systemd).

---

## Battery Limiter (`limiter.sh`)
Limits battery charging to 80% for longevity and switches fan mode based on AC/battery status (Dell-specific).

**How it works:**
- Sets charge threshold to 80% (if supported)
- Adjusts fan mode using `i8kctl` based on power source

**Usage:**
```bash
chmod +x limiter.sh
./limiter.sh
```
This script runs in a loop and may require root privileges for hardware control.

---

## Battery Lifespan Optimizer (`optimize_battery_lifespan.sh`)
Advanced script to optimize battery lifespan using dynamic thresholds, TLP integration, and systemd automation.

**How it works:**
- Applies TLP power management settings
- Dynamically sets battery charge thresholds based on temperature, cycle count, and capacity
- Disables turbo boost and applies kernel tweaks (if supported)
- Installs itself as a systemd service and timer for automatic periodic execution

**Usage:**
```bash
chmod +x optimize_battery_lifespan.sh
sudo ./optimize_battery_lifespan.sh
```
This script requires root privileges and will reboot the system for kernel changes to take effect.

---

---

## Requirements
- Linux system with battery info at `/sys/class/power_supply/BAT0`
- `bc`, `notify-send`, `paplay`, `acpi`, and (for Dell) `i8kctl` installed

---

## Troubleshooting
- If you see `Battery information not found.`, your battery may use a different path (e.g., `BAT1`). Edit the relevant variable in the script.
- If you see `Could not read battery capacity info.`, your system may not provide the required files, or you may need elevated permissions.
- For notifications and sound, ensure your desktop environment supports `notify-send` and `paplay`.
- For Dell fan control, `i8kctl` must be installed and supported.

---

## License
This project is licensed under the MIT License.