#! /system/bin/sh
sleep 300
logcat -c
logcat >> /mnt/media/udisk/aa.log &
gsr -p /data/stress -m 12000

busybox="/data/local/tmp/busybox"
log="/dev/kmsg"
buff=`netcfg`
ip=`echo $buff | cut -d ' ' -f 8`

if [ "x$ip" = "x192.168.88.100/24" ]; then
    reboot
else
    busybox date >> $log
    echo "No ip found" >> $log
fi
