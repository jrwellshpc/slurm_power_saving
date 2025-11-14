#!/usr/bin/env bash
# /etc/slurm/epilog.d/90-cpufreq-restore.sh
# Reset job CPUs to the hardware minimum ("low") rather than a fixed 800 MHz.

set -euo pipefail
: "${SLURM_JOB_ID:?missing}"
STATE_DIR="/run/slurm-cpufreq"
STATE="${STATE_DIR}/${SLURM_JOB_ID}.${HOSTNAME}.cpus"
LOGTAG="cpufreq-epilog[$SLURM_JOB_ID@$HOSTNAME]"

expand_cpulist() {
  local in="$1" out="" part a b i
  IFS=',' read -ra parts <<< "$in"
  for part in "${parts[@]}"; do
    if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
      a="${BASH_REMATCH[1]}"; b="${BASH_REMATCH[2]}"
      for ((i=a;i<=b;i++)); do out+=" $i"; done
    elif [[ "$part" =~ ^[0-9]+$ ]]; then
      out+=" $part"
    fi
  done
  echo "${out# }"
}

get_job_cpulist() {
  if [[ -f "$STATE" ]]; then cat "$STATE" && return; fi
  local hit
  hit=$(grep -rl "job_${SLURM_JOB_ID}" /sys/fs/cgroup 2>/dev/null | grep '/cpuset.cpus$' | head -n1 || true)
  [[ -n "$hit" ]] && { cat "$hit"; return; }
  echo "0-$(($(nproc --all)-1))"
}

# Determine the "low" frequency for a CPU (kHz).
min_khz_for_cpu() {
  local cpu="$1" base="/sys/devices/system/cpu/cpu${cpu}/cpufreq"
  local k=""
  [[ -r "$base/cpuinfo_min_freq" ]] && k="$(cat "$base/cpuinfo_min_freq" 2>/dev/null || true)"
  if [[ -z "$k" && -r "$base/scaling_available_frequencies" ]]; then
    # Take the lowest entry (list is usually high..low or low..high; be safe)
    k="$(tr ' ' '\n' < "$base/scaling_available_frequencies" | sort -n | head -n1)"
  fi
  # Final fallback: site baseline if you really want it (env/override), else 800 MHz
  if [[ -z "$k" ]]; then
    k="${BASE_FREQ_KHZ:-800000}"
  fi
  echo "$k"
}

cpulist="$(get_job_cpulist)"
cpus="$(expand_cpulist "$cpulist")"
[[ -n "$cpus" ]] || { logger -t "$LOGTAG" "WARN: empty CPU list; skipping."; exit 0; }

# Ensure userspace governor (your boot script should already do this).
for c in $cpus; do
  g="/sys/devices/system/cpu/cpu${c}/cpufreq/scaling_governor"
  [[ -w "$g" ]] && echo userspace > "$g" || true
done

# Set per-CPU min=max=lowest supported ("low")
for c in $cpus; do
  base="/sys/devices/system/cpu/cpu${c}/cpufreq"
  [[ -d "$base" ]] || continue
  k="$(min_khz_for_cpu "$c")"
  echo "$k" > "${base}/scaling_min_freq" 2>/dev/null || true
  echo "$k" > "${base}/scaling_max_freq" 2>/dev/null || true
  [[ -w "${base}/scaling_setspeed" ]] && echo "$k" > "${base}/scaling_setspeed" 2>/dev/null || true
done

rm -f "$STATE" 2>/dev/null || true
exit 0
