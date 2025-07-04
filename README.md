# SLURM Power Saving
## Example Scripts

The files in this repository will give you examples of what is need to get SLURM's Power Saving feature working.

The number one piece of advice that I received was to increase the timeouts to 10 minutes and wait. Everything in here is on a timer and you need to wait 10 minutes or whatever for those timers to timeout. Wait. You will not get this done in a day. Wait.

Also, I owe a huge thank you to Brian Haymore at the University of Utah for his help in getting all of this working.

Examples of the below steps are given under the SERVER_ROOT directory.

Wake-On-Lan Steps:
1. Configure the Hardware to do wake-on-lan. This may be done in Bios or a vendor specific command. Be sure to configure the network adapter you will use for sending (headnode?) and receiving (compute nodes?) wake-on-lan packets.
2. Get the wake-on-lan utility on your head node. If you are on Centos 7 like me, install net-tools. On SUSE flavors, it's netdiag. This gets you ether-wake, which is how we will wake the nodes when they are needed.
3. Create a file, /etc/ethers, which has all of your MAC addresses and what node they tie to. If you have multiple networks, you only need the mac addresses for the network you are going to use to carry wake-on-lan packets.

IPMI Steps:
1. Setup your IPMI/BMC hardware for access on the network you need the traffic to run over.

Final Steps:
1. Find a place to put your slurm_suspend.sh, node_suspend.sh, slurm_resume, and node_resume scripts. They need to be available on every node. Mine are in /opt/system/slurm/etc. Please note how I am using eth-tool to ensure the g bit is set on the network adapter before shutdown, so that wake-on-lan works if you can't use IPMI.
2. Ensure those .sh files are executable. Github seems to mess this up.
3. Edit slurm.conf with what I have in etc/slurm/slurm.conf. Be sure to change your SuspendProgram and ResumeProgram locations to where you put your scripts. You'll also want to set the suspendable nodes into a STATE=CLOUD. <-- VERY IMPORTANT. Then Save.
4. Run "scontrol reconfigure" to make the changes permanent.
5. Wait. Remember. Wait.
6. See if your idle nodes become idle~ in sinfo.
7. Run a job on those to bring them back.
8. See if they return to idle~ when they are idle once more.
9. You will likely need to ssh into 'down~' nodes and run 'systemctl restart slurmd'. If you see these you may want to extend the timeouts set it slurm.conf. Some nodes take 7 minutes to come back, FYI.

It may be useful to remember the sinfo codes:  
\*  The node is presently not responding and will not be allocated any new work. If the node remains non-responsive, it will be placed in the DOWN state (except in the case of COMPLETING, DRAINED, DRAINING, FAIL, FAILING nodes).  
\~  The node is presently powered off.  
\#  The node is presently being powered up or configured.  
\!  The node is pending power down.  
\%  The node is presently being powered down.  
\$  The node is currently in a reservation with a flag value of "maintenance".  
\@  The node is pending reboot.  
\^  The node reboot was issued.  
\-  The node is planned by the backfill scheduler for a higher priority job.  
