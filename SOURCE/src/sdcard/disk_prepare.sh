#!/usr/bin/env bash
set -euo pipefail

# disk_prepare.sh
# ------------------------------------------------------------
# WARNING:
# This script WILL cause irreversible data loss on the selected device.
# It writes to the beginning of the disk (default ~4 GiB), then attempts blkdiscard.
# If blkdiscard fails, it falls back to a full-device zero write.
# Finally, it creates a single partition spanning the whole device and quick-formats it as FAT32.
#
# UI output is written to /dev/tty so it works correctly even when using command substitution.
#
# Capacity-aware dd sizing:
# - Base test size is reduced automatically for small devices.
# - If disk < 8 GiB: --fast/--ultra are disabled (ignored with a warning).
# - If disk < 32 MiB: abort.
# ------------------------------------------------------------

BS="16M"
COUNT_DEFAULT="256"     # ~4 GiB
COUNT_FAST="128"        # ~2 GiB
COUNT_ULTRA="64"        # ~1 GiB (your "ultra")

ZERO_SRC="/dev/zero"
RAND_SRC="/dev/urandom"

DISK=""
FORCE=0
FAST=0
ULTRA=0

die() { echo "ERROR: $*" >&2; exit 1; }

tty_out()    { printf '%s\n' "$*" > /dev/tty; }
tty_printf() { printf "$@" > /dev/tty; }

usage() {
  cat > /dev/tty <<'EOF'
Usage:
  disk_prepare.sh                          # interactive disk selection + confirmation
  disk_prepare.sh --disk /dev/mmcblk0
  disk_prepare.sh -D /dev/sdb -F           # skip confirmation
  disk_prepare.sh -D /dev/mmcblk0 -f       # fast (count=128), only if disk >= 8 GiB
  disk_prepare.sh -D /dev/mmcblk0 -u       # ultra (count=64), only if disk >= 8 GiB

Options:
  -D, --disk <device>   Select disk non-interactively (e.g. /dev/mmcblk0, /dev/sdb)
  -F, --force           Skip the destructive confirmation prompt
  -f, --fast            Faster test (count=128). Disabled automatically if disk < 8 GiB.
  -u, --ultra           Ultra-fast test (count=64). Disabled automatically if disk < 8 GiB.
  -h, --help            Show this help
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -D|--disk)
        shift
        [[ $# -gt 0 ]] || die "--disk requires a device path (e.g. /dev/mmcblk0)"
        DISK="$1"
        shift
        ;;
      -F|--force)
        FORCE=1
        shift
        ;;
      -f|--fast)
        FAST=1
        shift
        ;;
      -u|--ultra)
        ULTRA=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1 (use --help)"
        ;;
    esac
  done
}

need_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    die "This script must be run as root (use sudo)."
  fi
}

need_deps() {
  command -v lsblk >/dev/null 2>&1 || die "lsblk not found."
  command -v dd >/dev/null 2>&1 || die "dd not found."
  command -v sync >/dev/null 2>&1 || die "sync not found."
  command -v partprobe >/dev/null 2>&1 || die "partprobe not found (package: parted)."
  command -v parted >/dev/null 2>&1 || die "parted not found."
  command -v mkfs.vfat >/dev/null 2>&1 || die "mkfs.vfat not found (package: dosfstools)."
  command -v python3 >/dev/null 2>&1 || die "python3 not found (required for mawk-safe math)."
}

# ---------------- mawk-safe numeric helpers (python3) ----------------

human_bytes() {
  local b="${1:-0}"
  python3 - <<PY
b=int("${b}")
units=["B","KiB","MiB","GiB","TiB","PiB"]
i=0
x=float(b)
while x>=1024 and i<len(units)-1:
  x/=1024.0
  i+=1
print(f"{x:.2f} {units[i]}")
PY
}

bytes_to_gib() {
  local b="${1:-0}"
  python3 - <<PY
b=int("${b}")
print(f"{b/(1024**3):.2f}")
PY
}

parse_dd_summary() {
  local line="$1"
  # Keep this awk usage minimal and mawk-safe (no match-capture arrays).
  # We split by fixed strings only.
  LC_ALL=C awk -v L="$line" '
    BEGIN {
      sec=""; rate=""
      n = split(L, a, / copied, /)
      if (n < 2) { print "|"; exit 0 }
      m = split(a[2], b, / s, /)
      if (m >= 1) sec = b[1]
      if (m >= 2) rate = b[2]
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", sec)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", rate)
      printf "%s|%s\n", sec, rate
    }
  '
}

run_dd() {
  local label="$1"; shift
  tty_out "==> ${label}"

  local out last parsed sec rate
  out="$(LC_ALL=C dd "$@" 2>&1)"
  last="$(printf '%s\n' "$out" | tail -n 1)"

  parsed="$(parse_dd_summary "$last")"
  sec="${parsed%%|*}"
  rate="${parsed#*|}"

  [[ -n "${sec}" && -n "${rate}" ]] || { sec="(unknown)"; rate="(unknown)"; }

  printf -v "${label}_DD_SUMMARY" '%s' "$last"
  printf -v "${label}_TIME_S" '%s' "$sec"
  printf -v "${label}_RATE" '%s' "$rate"
}

rate_to_mib_s() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"

  local num unit
  num="${s%% *}"
  unit="${s#* }"
  unit="${unit%/s}"

  [[ "$num" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo ""; return 0; }

  python3 - <<PY
import sys
num=float("${num}")
unit="${unit}"
if unit=="B":
  mib=num/(1024*1024)
elif unit=="kB":
  mib=(num*1000)/(1024*1024)
elif unit=="MB":
  mib=(num*1000*1000)/(1024*1024)
elif unit=="GB":
  mib=(num*1000*1000*1000)/(1024*1024)
elif unit=="KiB":
  mib=(num*1024)/(1024*1024)
elif unit=="MiB":
  mib=num
elif unit=="GiB":
  mib=num*1024
else:
  print("")
  sys.exit(0)
print(f"{mib:.2f}")
PY
}

grade_for_1080p_storage_speed() {
  local mib_s="$1"
  [[ -n "$mib_s" ]] || { echo 6; return 0; }
  python3 - <<PY
x=float("${mib_s}")
if x>=30: g=1
elif x>=20: g=2
elif x>=12: g=3
elif x>=8:  g=4
elif x>=5:  g=5
else:       g=6
print(g)
PY
}

grade_for_capacity() {
  local size_bytes="$1"
  python3 - <<PY
b=int("${size_bytes}")
gib=b/(1024**3)
if gib < 8: g=6
elif gib < 16: g=5
elif gib < 32: g=4
elif gib < 64: g=3
elif gib < 128: g=2
elif gib >= 128 and gib < 129: g=1
else: g=6
print(g)
PY
}

grade_average() {
  local g1="$1" g2="$2"
  python3 - <<PY
a=float("${g1}"); b=float("${g2}")
print(f"{(a+b)/2.0:.1f}")
PY
}

grade_label() {
  case "$1" in
    1) echo "1 (excellent)" ;;
    2) echo "2 (good)" ;;
    3) echo "3 (satisfactory)" ;;
    4) echo "4 (sufficient)" ;;
    5) echo "5 (poor)" ;;
    6) echo "6 (insufficient)" ;;
    *) echo "$1" ;;
  esac
}

compat_from_two_grades() {
  local speed_g="$1" cap_g="$2"
  if [[ "$speed_g" -ge 5 || "$cap_g" -ge 5 ]]; then
    echo "NOT COMPATIBLE (at least one category is grade >= 5)"
  else
    echo "COMPATIBLE"
  fi
}

# ---------------- disk selection ----------------

list_candidate_disks() {
  lsblk -b -P -n -o NAME,TYPE,SIZE,MODEL,TRAN,RM,HOTPLUG 2>/dev/null | \
  while IFS= read -r line; do
    NAME=""; TYPE=""; SIZE=""; MODEL=""; TRAN=""; RM=""; HOTPLUG=""
    eval "$line"

    [[ "$TYPE" == "disk" ]] || continue
    [[ "$TRAN" == "usb" || "$TRAN" == "mmc" || "$RM" == "1" || "$HOTPLUG" == "1" ]] || continue

    printf "/dev/%s|%s|%s|%s|%s|%s\n" "$NAME" "$SIZE" "$MODEL" "$TRAN" "$RM" "$HOTPLUG"
  done
}

choose_device() {
  local entries=()
  local line
  local choice idx
  local dev size_b model tran rm hp size_h

  while IFS= read -r line; do
    [[ -n "$line" ]] && entries+=("$line")
  done < <(list_candidate_disks)

  if [[ ${#entries[@]} -eq 0 ]]; then
    tty_out "Note: No candidate disks found."
    tty_out "Debug: lsblk -b -P -n -o NAME,TYPE,SIZE,MODEL,TRAN,RM,HOTPLUG:"
    lsblk -b -P -n -o NAME,TYPE,SIZE,MODEL,TRAN,RM,HOTPLUG > /dev/tty 2>&1 || true
    die "Aborting."
  fi

  tty_out "Detected candidate disks (USB/MMC/HOTPLUG/RM):"
  for i in "${!entries[@]}"; do
    IFS='|' read -r dev size_b model tran rm hp <<<"${entries[$i]}"
    [[ -n "$model" ]] || model="(no model)"
    [[ -n "$tran"  ]] || tran="(no transport)"
    size_h="$(human_bytes "$size_b")"
    tty_printf "  [%d] %s  (Size: %s, Model: %s, TRAN: %s, RM: %s, HOTPLUG: %s)\n" \
      "$((i+1))" "$dev" "$size_h" "$model" "$tran" "$rm" "$hp"
  done

  tty_out ""
  tty_printf "Select disk number to process: "
  IFS= read -r choice < /dev/tty
  [[ "$choice" =~ ^[0-9]+$ ]] || die "Invalid input (number expected)."

  idx=$((choice-1))
  (( idx >= 0 && idx < ${#entries[@]} )) || die "Selection out of range."

  IFS='|' read -r dev _ <<<"${entries[$idx]}"
  printf '%s\n' "$dev"
}

confirm_start() {
  local dev="$1"
  {
    echo
    echo "DESTRUCTIVE OPERATION WARNING:"
    echo "You are about to write to: ${dev}"
    echo "This will cause IRREVERSIBLE data loss."
    echo "Flow: overwrite beginning of disk, then blkdiscard (or fallback: full zero overwrite)."
    echo "After that: create a single FAT32 partition covering the whole device."
    echo
    printf "To continue, type exactly: YES  (anything else aborts): "
  } > /dev/tty

  local ack
  IFS= read -r ack < /dev/tty
  [[ "$ack" == "YES" ]] || die "Aborted."
}

ensure_not_mounted() {
  local dev="$1"
  if lsblk -n -o NAME,MOUNTPOINT "$dev" 2>/dev/null | awk 'NF>=2 && $2!="" {found=1} END{exit !found}'; then
    die "Device (or partitions) appear mounted on ${dev}. Unmount first and retry."
  fi
}

get_disk_size_bytes() {
  local dev="$1"
  if command -v blockdev >/dev/null 2>&1; then
    blockdev --getsize64 "$dev" 2>/dev/null || true
  else
    lsblk -b -dn -o SIZE "$dev" 2>/dev/null | head -n1 || true
  fi
}

# Capacity-driven count selection (per your mapping), using MiB thresholds:
# 4 GiB  -> count=128
# 2 GiB  -> count=64
# 1 GiB  -> count=32
# 512 MiB -> count=16
# 256 MiB -> count=8
# 128 MiB -> count=4
# 64 MiB  -> count=2
# 32 MiB  -> count=1
# < 32 MiB -> abort
#
# For >= 8 GiB, we keep default count=256 unless fast/ultra is requested.
capacity_count_override_for_small_disks() {
  local size_bytes="$1"
  python3 - <<PY
b=int("${size_bytes}")
mib=b/(1024**2)

def out(n): print(n)

# Abort threshold
if mib < 32:
  out(-1)
elif mib < 64:
  out(1)
elif mib < 128:
  out(2)
elif mib < 256:
  out(4)
elif mib < 512:
  out(8)
elif mib < 1024:
  out(16)
elif mib < 2048:
  out(32)
elif mib < 4096:
  out(64)
elif mib < 8192:
  # up to <8 GiB: cap at 2 GiB test
  out(128)
else:
  out(0)  # no override
PY
}

full_zero_fallback() {
  local dev="$1"
  {
    echo
    echo "FALLBACK: blkdiscard failed -> overwriting the ENTIRE device with /dev/zero (bs=${BS})."
    echo "This can take a long time depending on device size."
    echo
  } > /dev/tty

  dd if="$ZERO_SRC" of="$dev" bs="$BS" status=progress conv=fsync > /dev/tty 2>&1
  sync
}

partition_and_format_fat32() {
  local dev="$1"

  tty_out ""
  tty_out "==> Creating single partition spanning the whole device (MBR) and quick-formatting as FAT32"

  parted -s "$dev" mklabel msdos > /dev/tty 2>&1
  parted -s -a optimal "$dev" mkpart primary fat32 1MiB 100% > /dev/tty 2>&1

  partprobe "$dev" > /dev/tty 2>&1 || true
  sync
  sleep 2

  local part=""
  if [[ "$dev" =~ mmcblk[0-9]+$ || "$dev" =~ nvme[0-9]+n[0-9]+$ ]]; then
    part="${dev}p1"
  else
    part="${dev}1"
  fi

  [[ -b "$part" ]] || die "Partition device not found after partitioning: ${part}"

  mkfs.vfat -F 32 -n "DISK" "$part" > /dev/tty 2>&1
  sync

  tty_out "FAT32 format complete: ${part}"
}

main() {
  parse_args "$@"
  need_root
  need_deps

  local dev
  if [[ -n "$DISK" ]]; then
    dev="$DISK"
  else
    dev="$(choose_device)"
  fi

  [[ -b "$dev" ]] || die "${dev} is not a block device."
  ensure_not_mounted "$dev"

  local size_bytes size_h size_gib
  size_bytes="$(get_disk_size_bytes "$dev")"
  [[ -n "$size_bytes" ]] || size_bytes="0"
  size_h="$(human_bytes "$size_bytes")"
  size_gib="$(bytes_to_gib "$size_bytes")"

  # Enforce: if disk < 8 GiB, disable fast/ultra
  local eight_gib_bytes=$((8 * 1024 * 1024 * 1024))
  if (( size_bytes < eight_gib_bytes )); then
    if [[ "$FAST" -eq 1 || "$ULTRA" -eq 1 ]]; then
      tty_out "Note: Disk is smaller than 8 GiB (${size_h}). Disabling --fast/--ultra."
    fi
    FAST=0
    ULTRA=0
  fi

  if [[ "$FORCE" -ne 1 ]]; then
    confirm_start "$dev"
  else
    tty_out "Force mode enabled: skipping confirmation prompt."
  fi

  # Determine COUNT:
  # 1) If small-disk override applies, it wins and also implies fast/ultra off already when <8GiB.
  # 2) Else: apply --fast/--ultra
  # 3) Else: default
  local COUNT
  COUNT="$COUNT_DEFAULT"

  local override
  override="$(capacity_count_override_for_small_disks "$size_bytes")"
  if [[ "$override" == "-1" ]]; then
    die "Disk capacity is too small (${size_h}). Minimum required: 32 MiB."
  elif [[ "$override" != "0" ]]; then
    COUNT="$override"
    tty_out "Capacity override: disk=${size_h} -> dd count set to ${COUNT} (bs=${BS})."
  else
    if [[ "$FAST" -eq 1 ]]; then
      COUNT="$COUNT_FAST"
      tty_out "Fast mode enabled: dd count set to ${COUNT} (bs=${BS})."
    fi
    if [[ "$ULTRA" -eq 1 ]]; then
      COUNT="$COUNT_ULTRA"
      tty_out "Ultra fast mode enabled: dd count set to ${COUNT} (bs=${BS})."
    fi
  fi

  {
    echo
    echo "Starting write/read test on ${dev}"
    echo "Capacity: ${size_h} (${size_gib} GiB)"
    echo "Parameters: bs=${BS}, count=${COUNT}"
    echo
  } > /dev/tty

  run_dd "ZERO_WRITE" if="$ZERO_SRC" of="$dev" bs="$BS" count="$COUNT" conv=notrunc
  sync
  sleep 15

  run_dd "RAND_WRITE" if="$RAND_SRC" of="$dev" bs="$BS" count="$COUNT" conv=notrunc
  sync
  sleep 15

  run_dd "READ_TEST" if="$dev" of=/dev/null bs="$BS" count="$COUNT"
  sync

  # --- Grading: speed + capacity ---
  local zero_mib_s speed_grade cap_grade avg_grade compat verdict_line
  zero_mib_s="$(rate_to_mib_s "${ZERO_WRITE_RATE}")"

  speed_grade="$(grade_for_1080p_storage_speed "$zero_mib_s")"
  cap_grade="$(grade_for_capacity "$size_bytes")"
  avg_grade="$(grade_average "$speed_grade" "$cap_grade")"
  compat="$(compat_from_two_grades "$speed_grade" "$cap_grade")"

  if [[ "$speed_grade" -ge 5 || "$cap_grade" -ge 5 ]]; then
    verdict_line="Verdict: Device is considered NOT compatible for 1080p stream recording (one category is grade >= 5)."
  else
    verdict_line="Verdict: Device is considered compatible for 1080p stream recording."
  fi

  {
    echo
    echo "================== Results =================="
    echo "Device:                 $dev"
    echo "Capacity:               ${size_h} (${size_gib} GiB)"
    echo
    echo "1) /dev/zero  -> $dev"
    echo "   Time:               ${ZERO_WRITE_TIME_S} s"
    echo "   Rate:               ${ZERO_WRITE_RATE}"
    echo "   dd summary:          ${ZERO_WRITE_DD_SUMMARY}"
    echo
    echo "2) /dev/urandom -> $dev"
    echo "   Time:               ${RAND_WRITE_TIME_S} s"
    echo "   Rate:               ${RAND_WRITE_RATE}"
    echo "   dd summary:          ${RAND_WRITE_DD_SUMMARY}"
    echo
    echo "3) $dev -> /dev/null"
    echo "   Time:               ${READ_TEST_TIME_S} s"
    echo "   Rate:               ${READ_TEST_RATE}"
    echo "   dd summary:          ${READ_TEST_DD_SUMMARY}"
    echo
    echo "---- 1080p Camera Stream Storage Heuristic ----"
    if [[ -n "$zero_mib_s" ]]; then
      echo "Sustained sequential write (approx): ${zero_mib_s} MiB/s"
    else
      echo "Sustained sequential write (approx): (could not parse, treated as worst-case)"
    fi
    echo "Speed grade:                      $(grade_label "$speed_grade")"
    echo "Capacity grade:                   $(grade_label "$cap_grade")"
    echo "Average grade:                    ${avg_grade}"
    echo "Compatibility decision:           ${compat}"
    echo "${verdict_line}"
    echo "------------------------------------------------"
    echo
    echo "Waiting 30 seconds before blkdiscard ..."
  } > /dev/tty

  sleep 30

  if command -v blkdiscard >/dev/null 2>&1; then
    tty_out "==> blkdiscard -v ${dev}"
    if ! blkdiscard -v "$dev" > /dev/tty 2>&1; then
      tty_out "WARNING: blkdiscard failed (unsupported or device busy)."
      full_zero_fallback "$dev"
    else
      sync
    fi
  else
    tty_out "blkdiscard not available -> using fallback (full zero overwrite)."
    full_zero_fallback "$dev"
  fi

  partition_and_format_fat32 "$dev"
  tty_out "Done."
}

main "$@"
