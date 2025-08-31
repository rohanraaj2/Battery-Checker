#!/bin/bash
# ---------------------------------------------------
# Full Battery Lifespan Optimizer (Patched)
# BIOS-aware, TLP-integrated, Dynamic thresholds
# Creates systemd service & timer for automatic application
# ---------------------------------------------------

set -e

BAT_PATH="/sys/class/power_supply/BAT0"
TEMP_FILE="$BAT_PATH/temp"
START_FILE="$BAT_PATH/charge_control_start_threshold"
STOP_FILE="$BAT_PATH/charge_control_end_threshold"

# --------------------------
# 1. TLP config
# --------------------------
echo "==> Applying TLP settings..."
[ -f /etc/tlp.conf ] && cp /etc/tlp.conf /etc/tlp.conf.backup.$(date +%F-%T)

cat <<EOF >/etc/tlp.conf
# CPU / P-states
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_BOOST_ON_BAT=0

# Disk
DISK_IDLE_SECS=2
AHCI_RUNTIME_PM_ON_BAT=min_power

# USB
USB_AUTOSUSPEND=1
USB_BLACKLIST=""

# Wi-Fi
WIFI_PWR_ON_BAT=5

# Misc
RESTORE_DEVICE_STATE_ON_STARTUP=1
TLP_ENABLE=1
EOF

systemctl enable tlp
systemctl restart tlp

# --------------------------
# 2. Turbo boost
# --------------------------
if [ -w /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
    echo "==> Disabling Turbo Boost..."
    echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
else
    echo "==> Turbo boost control blocked by BIOS."
fi

# --------------------------
# 3. GRUB/kernel tweaks
# --------------------------
if [ -f /sys/module/intel_idle/parameters/max_cstate ]; then
    echo "==> Applying GRUB/kernel tweaks..."
    sed -i.bak 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_pstate=enable intel_idle.max_cstate=10 mem_sleep_default=deep"|' /etc/default/grub
    update-grub
else
    echo "==> C-state/deep sleep control blocked by BIOS."
fi

# --------------------------
# 4. Dynamic battery thresholds
# --------------------------
write_threshold() { local f=$1 v=$2; [ -w "$f" ] && echo "$v" > "$f"; }

TEMP_C=30
[ -f "$TEMP_FILE" ] && TEMP=$(cat "$TEMP_FILE") && TEMP_C=$((TEMP / 10))

CYCLES=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/cycle count/ {print $3}')
CYCLES=${CYCLES:-0}       # default to 0 if empty
CAPACITY=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/capacity/ {print int($2)}')
CAPACITY=${CAPACITY:-100} # default to 100 if empty

LOW=20
HIGH=80
[ "$TEMP_C" -gt 40 ] && HIGH=$((HIGH - 5))
[ "$CAPACITY" -lt 80 ] && HIGH=$((HIGH - 5))
[ "$CYCLES" -gt 500 ] && { LOW=$((LOW + 5)); HIGH=$((HIGH - 5)); }

write_threshold "$START_FILE" "$LOW"
write_threshold "$STOP_FILE" "$HIGH"

# --------------------------
# 5. Create systemd service & timer
# --------------------------
echo "==> Copying script to /usr/local/bin for systemd service..."
sudo cp "$0" /usr/local/bin/full_battery_optim_auto.sh
sudo chmod +x /usr/local/bin/full_battery_optim_auto.sh

SERVICE_FILE="/etc/systemd/system/full-battery-optim.service"
TIMER_FILE="/etc/systemd/system/full-battery-optim.timer"

echo "==> Creating systemd service and timer for automatic application..."
cat <<EOF >"$SERVICE_FILE"
[Unit]
Description=Full Battery Lifespan Optimizer
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/full_battery_optim_auto.sh
RemainAfterExit=yes
EOF

cat <<EOF >"$TIMER_FILE"
[Unit]
Description=Run Full Battery Optimizer every 10 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=10min
Unit=full-battery-optim.service

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable full-battery-optim.timer
systemctl start full-battery-optim.timer

echo "==> Done! Reboot is required for GRUB/kernel changes to take effect."
