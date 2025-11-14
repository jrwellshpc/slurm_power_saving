# SLURM Power Saving: Defrag Slurm
## Status

This project is on my to do list and should happen in the wanning weeks of 2025. It will use a cron job that runs every 4 hours or so to find nodes with less than 50% utilization and then move the jobs on them to another node with similar utilization. It will do this for CPU nodes with CRIU, and NVIDIA GPU nodes with CUDA-Checkpoint. I greatly encourage participation from all and would really like AMD to work on a similar checkpointing code project.
