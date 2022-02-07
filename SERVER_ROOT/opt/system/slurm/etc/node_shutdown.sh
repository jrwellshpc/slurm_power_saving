#!/bin/bash
# Let's first ensure it'll respond to the magic packet since it is more secure
# and how the ether-wake command works
ssh $1 "ethtool -s enp2s0 wol g"
# Then power down through shutdown...
ssh $1 "shutdown -h now"
# or IPMI (but note you'd need to retreive the IPMI address, not the interconnect)...
#ipmitool -H $1 -v -I lanplus -U username -P userpassword chassis power off
