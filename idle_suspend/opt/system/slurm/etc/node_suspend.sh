#!/bin/bash
# Let's first ensure it'll respond to the magic packet since it is more secure
# and how the ether-wake command works
ssh $1 "ethtool -s enp2s0 wol g"
# Then power down through shutdown...
ssh $1 "shutdown -h now"
# or use IPMI (but note you'd need to retreive the IPMI address, not the main address)...
#ipmitool -I lanplus -SSL -U user -P password -H host.name.edu chassis power off
