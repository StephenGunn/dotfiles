#!/bin/bash
# GPU monitor for AMD RX 7900 XTX (card1, PCI 0000:03:00.0)
# Logs interesting GPU activity (high usage, temp, fan, power) with process info.
# Designed to run as a systemd user service.

CARD=card1
PCI_ADDR="0000:03:00.0"
LOG_DIR="$HOME/.local/share/gpu-monitor"
LOG_FILE="$LOG_DIR/gpu.log"
MAX_LOG_SIZE=$((10 * 1024 * 1024))  # 10MB
INTERVAL=2

# Thresholds
BUSY_THRESH=50    # percent
TEMP_THRESH=70    # celsius
FAN_THRESH=1200   # rpm
POWER_THRESH=150  # watts

# Resolve hwmon path (number can change across boots)
HWMON_DIR=$(echo /sys/class/drm/$CARD/device/hwmon/hwmon*)

mkdir -p "$LOG_DIR"

rotate_log() {
    local size
    size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
    if (( size > MAX_LOG_SIZE )); then
        mv "$LOG_FILE" "$LOG_FILE.1"
    fi
}

read_sysfs() {
    cat "$1" 2>/dev/null || echo ""
}

# Find processes actively using the GPU via fdinfo.
# Looks for drm-pdev matching our card with meaningful gfx engine time.
find_gpu_processes() {
    local pids=""
    for fdinfo in /proc/[0-9]*/fdinfo/*; do
        [[ -r "$fdinfo" ]] || continue
        local content
        content=$(cat "$fdinfo" 2>/dev/null) || continue

        # Must reference our PCI device
        echo "$content" | grep -q "drm-pdev:.*$PCI_ADDR" || continue

        # Check for nonzero gfx engine time (value in nanoseconds)
        local gfx_ns
        gfx_ns=$(echo "$content" | grep -oP 'drm-engine-gfx:\s*\K[0-9]+')
        [[ -n "$gfx_ns" ]] && (( gfx_ns > 0 )) || continue

        local pid
        pid=$(echo "$fdinfo" | cut -d/ -f3)
        local comm
        comm=$(read_sysfs "/proc/$pid/comm")
        [[ -n "$comm" ]] && pids="$pids $comm($pid)"
    done
    echo "${pids# }"
}

# Parse current sclk from pp_dpm_sclk (line marked with *)
read_clock() {
    local line
    line=$(grep '\*' "/sys/class/drm/$CARD/device/pp_dpm_sclk" 2>/dev/null)
    echo "$line" | grep -oP '[0-9]+(?=Mhz)' || echo ""
}

while true; do
    busy=$(read_sysfs "/sys/class/drm/$CARD/device/gpu_busy_percent")
    temp_raw=$(read_sysfs "$HWMON_DIR/temp1_input")
    power_raw=$(read_sysfs "$HWMON_DIR/power1_average")
    fan=$(read_sysfs "$HWMON_DIR/fan1_input")
    clock=$(read_clock)

    # Convert units
    temp=""
    [[ -n "$temp_raw" ]] && temp=$(( temp_raw / 1000 ))
    power=""
    [[ -n "$power_raw" ]] && power=$(( power_raw / 1000000 ))

    # Check if anything is interesting
    interesting=0
    (( ${busy:-0} > BUSY_THRESH )) && interesting=1
    (( ${temp:-0} > TEMP_THRESH )) && interesting=1
    (( ${fan:-0} > FAN_THRESH )) && interesting=1
    (( ${power:-0} > POWER_THRESH )) && interesting=1

    if (( interesting )); then
        ts=$(date '+%Y-%m-%d %H:%M:%S')
        procs=$(find_gpu_processes)

        line="[$ts] busy=${busy}% temp=${temp}C power=${power}W fan=${fan}rpm clock=${clock}MHz"
        [[ -n "$procs" ]] && line="$line procs=[$procs]"

        echo "$line" >> "$LOG_FILE"
        rotate_log
    fi

    sleep "$INTERVAL"
done
