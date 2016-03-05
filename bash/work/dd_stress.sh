#! /data/local/tmp/busybox sh



source=$1
dest="/cache/update.zip"
busybox="/data/local/tmp/busybox"
log="/data/dd_stress.log"

echo "Start dd_stress" >> $log 
sum=`$busybox sha1sum $source`
a=${sum:0:40}
echo $sum >> $log
if [ -f $dest ]; then
   sum=`$busybox sha1sum $dest`
   b=${sum:0:40}
   echo $sum >> $log
   if [ $a != $b ]; then
       echo "Mismatch !!" >> $log
       exit 0
   fi
fi

$busybox dd if=$source of=$dest >> $log
sum=`$busybox sha1sum $dest`
b=${sum:0:40}
echo $sum >> $log
if [ $a = $b ]; then
#    echo "reboot"
    reboot
fi

