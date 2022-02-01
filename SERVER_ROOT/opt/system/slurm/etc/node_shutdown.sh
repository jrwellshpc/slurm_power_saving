#!/bin/bash
# Let's first ensure it'll respond to the magic packet since it is more secure
# and how the ether-wake command works
ssh $1 "ethtool -s enp2s0 wol g"
ssh $1 "shutdown -h now"
