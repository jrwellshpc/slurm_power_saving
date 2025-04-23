#!/bin/bash
# If using Wake-On-Lan on RHEL or variants:
ether-wake $1
# If using IPMI:
#ipmitool -I lanplus -SSL -U user -P password -H host.name.edu chassis power up
