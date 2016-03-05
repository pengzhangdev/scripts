#! /data/local/tmp/busybox sh

busybox="/data/local/tmp/busybox"
log="/dev/kmsg"

sleep 50

buff=`netcfg`
ip=`echo $buff | cut -d ' ' -f 8`
if [ "x$ip" = "x192.168.88.100/24" ]; then
    reboot
else
    echo "No ip found" >> $log
fi
