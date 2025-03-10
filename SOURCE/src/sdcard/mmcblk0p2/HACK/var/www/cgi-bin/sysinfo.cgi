#!/bin/sh

root="/tmp/sd/HACK"

. ./common.cgi

MEM_TOTAL=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
MEM_FREE=$(awk '/MemFree/ {print $2}' /proc/meminfo)
MEM_AVAILABLE=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)

CPU_MODEL=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
CPU_CORES=$(awk '/^processor/ {count++} END {print count}' /proc/cpuinfo)

UPTIME_SECONDS=$(awk '{print $1}' /proc/uptime)
UPTIME_HUMAN=$(awk '{printf "%d Tage, %02d:%02d:%02d\n", $1/86400, ($1%86400)/3600, ($1%3600)/60, $1%60}' /proc/uptime)

LOAD_1MIN=$(awk '{print $1}' /proc/loadavg)
LOAD_5MIN=$(awk '{print $2}' /proc/loadavg)
LOAD_15MIN=$(awk '{print $3}' /proc/loadavg)

CPU_USAGE=0

CPU1=$(awk '/^cpu / {print $2, $3, $4, $5}' /proc/stat)
sleep 1
CPU2=$(awk '/^cpu / {print $2, $3, $4, $5}' /proc/stat)

CPU1_USER=$(echo $CPU1 | awk '{print $1}')
CPU1_NICE=$(echo $CPU1 | awk '{print $2}')
CPU1_SYSTEM=$(echo $CPU1 | awk '{print $3}')
CPU1_IDLE=$(echo $CPU1 | awk '{print $4}')

CPU2_USER=$(echo $CPU2 | awk '{print $1}')
CPU2_NICE=$(echo $CPU2 | awk '{print $2}')
CPU2_SYSTEM=$(echo $CPU2 | awk '{print $3}')
CPU2_IDLE=$(echo $CPU2 | awk '{print $4}')

CPU_DELTA_USER=$((CPU2_USER - CPU1_USER))
CPU_DELTA_NICE=$((CPU2_NICE - CPU1_NICE))
CPU_DELTA_SYSTEM=$((CPU2_SYSTEM - CPU1_SYSTEM))
CPU_DELTA_IDLE=$((CPU2_IDLE - CPU1_IDLE))
CPU_TOTAL=$((CPU_DELTA_USER + CPU_DELTA_NICE + CPU_DELTA_SYSTEM + CPU_DELTA_IDLE))

if [ "$CPU_TOTAL" -gt 0 ]; then
    CPU_USAGE=$((100 * (CPU_DELTA_USER + CPU_DELTA_NICE + CPU_DELTA_SYSTEM) / CPU_TOTAL))
fi

send_header application/json
cat <<EOF
{
  "memory": {
    "total_kB": $MEM_TOTAL,
    "free_kB": $MEM_FREE,
    "available_kB": $MEM_AVAILABLE
  },
  "cpu": {
    "model": "$(echo $CPU_MODEL | sed 's/"/\\"/g')",
    "cores": $CPU_CORES,
    "usage_percent": $CPU_USAGE
  },
  "uptime": {
    "seconds": $UPTIME_SECONDS,
    "human_readable": "$UPTIME_HUMAN"
  },
  "load": {
    "min1": $LOAD_1MIN,
    "min5": $LOAD_5MIN,
    "min15": $LOAD_15MIN
  }
}
EOF
