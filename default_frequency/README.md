# SLURM Power Saving: Default Frequency
## Steps
1. This will not work with PSTATES. In your grub.conf you must add intel_pstate=disable to GRUB_CMDLINE_LINUX_DEFAULT. This will prevent the hardware from setting the core frequency so we can manipulate it. An example is included.
2. A Systemd service will set the frequency of all the cores to low (usually 800MHz) on boot using cpufrequency. An example is included. Do not forget to run "systemctl enable set-cpu-lowest-freq.service" and reboot.
3. There is a job script wrapper to utilize Slurm's frequency setting to automatically adjust user's jobs to use the highest frequency available.
4. There is also a prolog script to grab the cores affected by the job submission, and a epilog to set those cores back to low (800MHz-ish). 
