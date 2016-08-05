#! /system/bin/sh

process_name=zygote

function clear_cache
{
    #rm -rf /data/dalvik-cache/*
    echo "clear cache"
}


########## DONT MODIFY THE FOLLOWING CODE ###############

property_name=${process_name}.crashed.info

last_crashed=$(getprop property_name)
crashed_count=0
first_crashed_time=0
if [ -z "$last_crashed" ]; then
    crashed_count=0
    first_crashed_time=0
else
    arr=(${last_crashed//:/ })
    crashed_count=${arr[0]}
    first_crashed_time=${arr[1]}
fi

tmp=$(cat /proc/uptime)
echo "uptime $tmp"
uptime=($tmp)
current_time=${uptime[0]}
current_time=${current_time%.*}
echo "current_time $current_time"

if [ first_crashed_time -eq 0 ]; then
    first_crashed_time=$current_time
fi

delta_time=$(($current_time-$first_crashed_time))
crashed_count=$(($crashed_count+1))

if [ delta_time -le 240 ]; then
    setprop $property_name ${crashed_count}:${first_crashed_time}
    if [ crashed_count -ge 4 ]; then
        clear_cache
        setprop $property_name ""
    fi
else
    first_crashed_time=$current_time
    crashed_count=1
    setprop $property_name ${crashed_count}:${first_crashed_time}
fi

