#!/usr/bin/env bash
# Runs as root on the compute node before the job starts on this node.
set -euo pipefail

: "${SLURM_JOB_ID:?missing}"
STATE_DIR="/run/slurm-cpufreq"
mkdir -p "$STATE_DIR"
STATE="${STATE_DIR}/${SLURM_JOB_ID}.${HOSTNAME}.cpus"

# Try the job cgroup (cgroup v2) first.
cpus=""
if [[ -f /sys/fs/cgroup/cpuset.cpus ]]; then
  # Search for this job's cpuset.cpus files
  cpus=$(grep -rl "job_${SLURM_JOB_ID}" /sys/fs/cgroup 2>/dev/null | \
         grep '/cpuset.cpus$' | xargs -r cat | sort -u | paste -sd, -)
fi

# Fallbacks:
if [[ -z "$cpus" ]]; then
  # If Slurm baked a cpulist into the environment on this node, use it.
  if [[ -n "${SLURM_JOB_CPUS_PER_NODE:-}" ]]; then
    # SLURM_JOB_CPUS_PER_NODE is a count; not ideal. Use all online CPUs as worst-case.
    cpus="0-$(($(nproc --all)-1))"
  else
    cpus="0-$(($(nproc --all)-1))"
  fi
fi

echo "$cpus" > "$STATE"
chmod 600 "$STATE"
exit 0
