#!/bin/bash
# ---------------------------------------------------
# Full Battery Lifespan Optimizer (Patched)
# BIOS-aware, TLP-integrated, Dynamic thresholds
# Creates systemd service & timer for automatic application
# ---------------------------------------------------

set -e

BAT_PATH="/sys/class/power_supply/BAT0"
source "$(dirname "$0")/battery_utils.sh"

# --- Main Execution ---
apply_tlp_settings
disable_turbo_boost
apply_grub_kernel_tweaks
set_dynamic_battery_thresholds "$BAT_PATH"
setup_systemd_service_and_timer "$0"

echo "==> Done! Reboot is required for GRUB/kernel changes to take effect."
