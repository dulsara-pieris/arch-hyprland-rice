#!/usr/bin/env bash

# Hyprland Resource Watch
# Detects sustained CPU/GPU load and switches performance state.
#
# CPU: /proc/stat
# GPU: intel_gpu_top JSON
#
# Normal  -> CPU < 40% AND GPU < 40%
# Heavy   -> CPU >= 60% OR GPU >= 60%
#
# Heavy load must persist for 3 samples.
# Low load must persist for 5 samples.

set -u

# -----------------------------
# Configuration
# -----------------------------

CPU_HIGH=60
GPU_HIGH=60

CPU_LOW=40
GPU_LOW=40

CHECK_INTERVAL=2

HIGH_SAMPLES=3
LOW_SAMPLES=5

GPU_DEVICE="/dev/dri/card1"

# -----------------------------
# State
# -----------------------------

STATE="normal"

high_count=0
low_count=0

# -----------------------------
# Notifications
# -----------------------------

notify() {
    notify-send \
        --app-name="Resource Watch" \
        --icon="speedometer" \
        "$1" \
        "$2"
}

# -----------------------------
# CPU usage
# -----------------------------

get_cpu_usage() {
    local user nice system idle iowait irq softirq steal
    local prev_total prev_idle
    local total idle total_delta idle_delta

    read -r _ user nice system idle iowait irq softirq steal _ \
        < /proc/stat

    prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    prev_idle=$((idle + iowait))

    sleep 0.25

    read -r _ user nice system idle iowait irq softirq steal _ \
        < /proc/stat

    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle=$((idle + iowait))

    total_delta=$((total - prev_total))
    idle_delta=$((idle - prev_idle))

    if (( total_delta <= 0 )); then
        echo 0
        return
    fi

    echo $((100 * (total_delta - idle_delta) / total_delta))
}

# -----------------------------
# GPU usage
# -----------------------------

get_gpu_usage() {
    local json

    json="$(
        intel_gpu_top \
            -J \
            -d "drm:${GPU_DEVICE}" \
            -s 500 \
            -n 1 2>/dev/null
    )"

    if [[ -z "$json" ]]; then
        echo 0
        return
    fi

    jq -r '.[0].engines["Render/3D"].busy // 0' <<< "$json" |
        awk '{printf "%d\n", $1}'
}

# -----------------------------
# Performance state
# -----------------------------

enter_performance() {
    [[ "$STATE" == "performance" ]] && return

    STATE="performance"
    high_count=0
    low_count=0

    notify \
        "🚀 Performance mode" \
        "Heavy workload detected."
}

leave_performance() {
    [[ "$STATE" == "normal" ]] && return

    STATE="normal"
    high_count=0
    low_count=0

    notify \
        "🌿 Normal mode" \
        "System workload has dropped."
}

# -----------------------------
# Main loop
# -----------------------------

while true; do

    CPU=$(get_cpu_usage)
    GPU=$(get_gpu_usage)

    printf '[resource-watch] CPU=%3s%% GPU=%3s%% STATE=%s\n' \
        "$CPU" "$GPU" "$STATE"

    # -------------------------
    # Heavy workload detection
    # -------------------------

    if (( CPU >= CPU_HIGH || GPU >= GPU_HIGH )); then
        ((high_count += 1))
        low_count=0
    else
        high_count=0
    fi

    if (( high_count >= HIGH_SAMPLES )); then
        enter_performance
    fi

    # -------------------------
    # Return to normal
    # -------------------------

    if (( CPU <= CPU_LOW && GPU <= GPU_LOW )); then
        ((low_count += 1))
        high_count=0
    else
        low_count=0
    fi

    if (( low_count >= LOW_SAMPLES )); then
        leave_performance
    fi

    sleep "$CHECK_INTERVAL"

done