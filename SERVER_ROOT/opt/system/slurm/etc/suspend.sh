#!/bin/bash
# Example SuspendProgram
echo "`date` Suspend invoked $0 $*" >> /var/log/power_save.log
hosts=`scontrol show hostnames $1`
for host in $hosts
do
   echo "Suspending " $host >> /var/log/power_save.log
   sudo /opt/system/slurm/etc/node_shutdown.sh $host &>> /var/log/power_save.log
done
