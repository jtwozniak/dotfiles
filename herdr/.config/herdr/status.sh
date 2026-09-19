#!/usr/bin/env bash
set -euo pipefail

weather=$(curl -fsS --max-time 1 'https://wttr.in/Gubin?format=%t' 2>/dev/null || true)

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total_before=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_before=$((idle + iowait))
sleep 0.1
read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total_after=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_after=$((idle + iowait))
cpu=$((100 * ((total_after - total_before) - (idle_after - idle_before)) / (total_after - total_before)))

mem_total=$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)
mem_available=$(awk '/^MemAvailable:/ { print $2 }' /proc/meminfo)
mem_used=$((mem_total - mem_available))
read -r ram_used ram_total < <(awk -v used="$mem_used" -v total="$mem_total" 'BEGIN { printf "%.1f %.1f\n", used / 1048576, total / 1048576 }')

printf 'Gubin %-5.5s | CPU %3d%% | RAM %5.1f/%5.1f GiB\n' "${weather:-n/a}" "$cpu" "$ram_used" "$ram_total"
