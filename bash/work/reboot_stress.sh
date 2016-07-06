#! /system/bin/sh
#
# reboot_stress.sh ---
#
# Filename: reboot_stress.sh
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Tue Jul  5 10:01:22 2016 (+0800)
#

# Change Log:
#
#

# reboot and check partitions
# $'\n'

function getPartitionNum()
{
    count=0
    for ar in `blkid /dev/block/sd*`
    do
        if [[ $ar == UUID* ]]; then
            count=$((count+1))
        fi
    done
    echo $count
}

function getMountPointNum()
{
    count=0
    for ar in `ls /storage/udisk/`
    do
	count=$((count+1))
    done
    echo $count
    
}

logcat > /data/reboot.log &
child_pid=$!

n=$(getPartitionNum)
m=$(getMountPointNum)

echo "n =" $n "m =" $m

if [ n -eq 0 ]; then
    exit 0
fi

if [ m -lt n ]; then
    sleep 20;
fi

if [ m -gt n ]; then
    sleep 20;
fi

if [ m -gt n ]; then
    kill -9 $child_pid
else
    reboot
fi


