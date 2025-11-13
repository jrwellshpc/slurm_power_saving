#!/bin/sh
# This is a script to be run by cron that should run daily (0 0 * * *) and do maintenance tasks, like ensure your 
# environment stays up to date. The below will print a list of the suspended nodes:
sinfo | grep idle~ | awk '{print $6}' | xargs -I {} scontrol show hostname {} 2>/dev/null

# from there you might consider adding "| xargs -I {} ipmitool flagsGoHere {} chassis power on 2>/dev/null" to the end. 
# That would then boot the nodes, allowing the configuration steps to complete, and then your existing timeout would 
# suspend the node.
