# Battery Wear Level Check

This repository provides a simple Bash script to check the wear level of your laptop battery on Linux systems.

## What is Battery Wear Level?
Battery wear level indicates the percentage of battery capacity lost compared to its original design capacity. A higher wear level means your battery holds less charge than when it was new.

## How It Works
The script reads battery information from `/sys/class/power_supply/BAT0` and calculates the wear level using the following formula:

```
Wear Level (%) = (1 - Current Full Capacity / Design Full Capacity) * 100
```

## Usage

1. **Clone the repository or download the script:**
   ```bash
   git clone https://github.com/rohanraaj2/Battery-Wear-Level-Check.git
   cd Battery-Wear-Level-Check
   ```

2. **Make the script executable:**
   ```bash
   chmod +x battery_wear.sh
   ```

3. **Run the script:**
   ```bash
   ./battery_wear.sh
   ```

   You should see output similar to:
   ```
   Battery Wear Level: 7.25%
   ```

## Requirements
- Linux system with battery information available at `/sys/class/power_supply/BAT0`
- `bc` command-line calculator installed

## Troubleshooting
- If you see `Battery information not found.`, your battery may use a different path (e.g., `BAT1`). Edit the `BAT_PATH` variable in the script accordingly.
- If you see `Could not read battery capacity info.`, your system may not provide the required files, or you may need to run the script with elevated permissions.

## License
This project is licensed under the MIT License.
