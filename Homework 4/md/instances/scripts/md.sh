#!/bin/bash
disk1=` ls /dev/ |  grep -v xvda | grep xvd | head -1 | tail -n1`
disk2=` ls /dev/ |  grep -v xvda | grep xvd | head -2 | tail -n1`
disk3=` ls /dev/ |  grep -v xvda | grep xvd | head -3 | tail -n1`
yum -y install mdadm  &&
mdadm --create --verbose /dev/md0 -l 0 -n 3 /dev/$disk1 /dev/$disk2 /dev/$disk3  && #create RAID0 S
mkdir /etc/mdadm  && #create folder mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf  && #create config file
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf  &&
mkfs.ext4 /dev/md0  && #format ext4 RAID0
mount /dev/md0 /mnt/ #mount RAID0
