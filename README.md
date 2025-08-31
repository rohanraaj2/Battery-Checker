# Battery Checker

>This repository provides Bash scripts to help monitor and manage your laptop battery health on Linux systems. All scripts now use a shared utility file (`battery_utils.sh`) for common functions.

## Table of Contents
 - [Wear Level Checker](#wear-level-checker)
 - [Battery Notifier](#battery-notifier)
 - [Battery Limiter](#battery-limiter)
 - [Battery Lifespan Optimizer](#battery-lifespan-optimizer)
 - [Shared Utilities](#shared-utilities)
 - [Requirements](#requirements)
 - [Troubleshooting](#troubleshooting)
 - [License](#license)

---

## Shared Utilities (`battery_utils.sh`)
Common functions for battery management, such as TLP configuration, turbo boost control, kernel tweaks, dynamic battery thresholds, and systemd setup. All main scripts source this file for modularity and code reuse.

---

## Wear Level Checker (`wear_level.sh`)
Calculates and displays the battery wear level (percentage of capacity lost compared to original design).

**Usage:**
```bash
chmod +x wear_level.sh
./wear_level.sh
```

---

## Battery Notifier (`notifier.sh`)
Sends a desktop notification and sound alert when the battery is fully charged (80%).

**Usage:**
```bash
chmod +x notifier.sh
./notifier.sh
```

---

## Battery Limiter (`limiter.sh`)
Sets battery charge thresholds using shared logic from `battery_utils.sh`.

**Usage:**
```bash
chmod +x limiter.sh
./limiter.sh
```

---

## Battery Lifespan Optimizer (`optimize_battery_lifespan.sh`)
Advanced script that dynamically manages battery charge thresholds, applies TLP power management, disables turbo boost, tweaks kernel settings, and sets up a systemd service/timer for automatic execution. Uses all shared utilities.

**Usage:**
```bash
chmod +x optimize_battery_lifespan.sh
sudo ./optimize_battery_lifespan.sh
```

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