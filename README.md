# SLURM Power Saving
## Projects
In this repo you will find three directories for three Slurm Power Saving projects:
1. idle_suspend suspends nodes that have gone idle for a defined time period.
2. defrag_slurm tries to concentrate jobs onto as few nodes as possible so there are more nodes for idle_suspend to suspend.
3. default_frequency sets the default frequency of your cluster's cores to 800MHz and then spikes them to their highest state when a job is run. The critical bit is that it spikes only the cores that are being used. The rest of the cores in the node(s) stay at 800MHz.

## Results
1. Due to OBMs we saw the idle_suspend project decrease power usuage from 600-1000W down to 130W. This savings is of course dependent on the number of idle nodes.
2. We estimate that 10% of nodes could be freed up for idle_suspend on our cluster. Your mileage may vary.
3. Default_frequency decreased power usage on completely idle CPU nodes from 600W to 250W, and completely idle GPU nodes (4x V100) from 1000W to 900W.

## Q&A
1. Yes, the decrease in default_frequency for GPU nodes was disappointing.
2. Yes, I tried to create a fourth project to get the GPUs to use less idle energy, but they do a good job of it already. Any future work here will have to dynamically remove them from the kernel to be of use.
3. Yes, defrag_slurm is possible because NVIDIA released CUDA Checkpoint based on CRIU. AMD take note, please! We are agnostic here!
4. HPC is about Time to Science. We are focusing are scavenging unused resources here. There is a whole world beyond this in the userspace, such as finding ideal frequencies for code to run at, and educating users about benchmarking and asking for too many resources. I may add these in the future. We like Princeton's Job Stats for that second idea though!
