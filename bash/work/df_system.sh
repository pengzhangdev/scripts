#! /system/bin/sh
#
# system_free.sh --- 
# 
# Filename: system_free.sh
# Description: 
# Author: Werther Zhang
# Maintainer: 
# Created: Tue Jul 19 15:53:08 2016 (+0800)
# 

# Change Log:
# 
# 


tmp=`df /system`

echo $tmp
arr=($tmp)
total_s=${arr[6]}
used_s=${arr[7]}
total=${total_s%.*}
used=${used_s%.*}
percent=$(($used*100/$total))
free=$((100-$percent))
echo "total=" $total "M used=" $used "M ("$percent%")" " free=" $free "%"

if [ free -lt 10 ]; then
    echo "FAILED: only $free% free space left in system partition"
else
    echo "SUCCESS: $free% free space left in system partition"
fi

