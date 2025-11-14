# SLURM Power Saving: Default Frequency
## Steps
1. This will not work with PSTATES. In your grub.conf you must add intel_pstate=disable to GRUB_CMDLINE_LINUX_DEFAULT. This will prevent the hardware from setting the core frequency so we can manipulate it.
2. A Systemd service will set the frequency of all the cores to 800MHz on boot.
3. There is a job script wrapper to utilize Slurm's frequency setting to automatically adjust user's jobs to use the highest frequency available.
