#!/bin/bash
# If using Wake-On-Lan on RHEL or variants:
ether-wake $1
# If using Wake-On-Lan on SUSE
#
# If using IPMI:
#ipmitool -u $username -p $password -I lanplus -h $host chassis power up
