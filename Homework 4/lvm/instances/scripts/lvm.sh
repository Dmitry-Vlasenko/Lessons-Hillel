#!/bin/bash
disk1=` ls /dev/ |  grep -v xvda | grep xvd | head -1 | tail -n1`
disk2=` ls /dev/ |  grep -v xvda | grep xvd | head -2 | tail -n1`
disk3=` ls /dev/ |  grep -v xvda | grep xvd | head -3 | tail -n1`
yum -y install lvm2 &&
pvcreate /dev/$disk1 /dev/$disk2 /dev/$disk3  && #initialize dev
vgcreate vol_grp1 /dev/$disk1 /dev/$disk2 /dev/$disk3  && #creation grp
lvcreate -l 100%FREE -n logical_vol1 vol_grp1 && #creation logical toms
mkfs.ext4 /dev/vol_grp1/logical_vol1  && #format ext4 logical toms
mount /dev/vol_grp1/logical_vol1 /mnt/ #mount
