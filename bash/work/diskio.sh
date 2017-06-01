#! /system/bin/sh
#
# diskio.sh ---
#
# Filename: diskio.sh
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Mon May 15 14:41:24 2017 (+0800)
#

# Change Log:
#
#

partition_list=("mmcblk0p16" "mmcblk0p14" "mmcblk0p15" "mmcblk0p11")
partition_name_list=("userdata" "system" "cache" "dvbdata")

sector_size=`cat /sys/block/mmcblk0/queue/hw_sector_size`

# contents:
# major  minor name   F1   F2    F3     F4    F5     F6    F7      F8    F9  F10  F11
# 179       0 mmcblk0 6595 2308 706550 19900 236237 28214 1880768 233220 0 105800 252960
# F1 : This is the total number of reads completed successfully.
# F2 : Total number of reads merged
# F3 : This is the total number of sectors read successfully.
# F4 : This is the total number of milliseconds spent by all reads
# F5 : This is the total number of writes completed successfully.
# F6 : Total number of writes merged
# F7 : This is the total number of sectors written successfully.
# F8 : This is the total number of milliseconds spent by all writes
# F9 : Number of I/Os currently in progress. The only field that should go to zero.
# F10: Milliseconds spent doing I/Os. This field increases so long as field 9 is nonzero.
# F11: milliseconds spent doing I/Os. 
diskiopath="/proc/diskstats"


echo $partition_list
echo $partition_name_list

last_parsed_time=0
last_read_count=0
last_read_section_count=0
last_write_count=0
last_write_section_count=0

for partition_name in $partition_name_list
do
    eval last_${partition_name}_read_count=0
    eval last_${partition_name}_read_section_count=0
    eval last_${partition_name}_write_count=0
    eval last_${partition_name}_write_section_count=0
done

parse_partitions()
{
    buff=`cat $diskiopath`
    parsed_time=`date +%s`
    partition_index=0
    echo $parsed_time
    time_elapsed=$(($parsed_time - $last_parsed_time))
    echo "`date` ======== time elapsed $time_elapsed s ========"
    echo $partition_list
    for partition in ${partition_list[@]}
    do
        entry=`cat $diskiopath | grep $partition`
        index=0
        read_count=0;
        read_section_count=0;
        write_count=0;
        write_section_count=0;
        echo "entry : $entry"
        for field in $entry
        do
            if [ $index -eq 3 ]; then
                read_count=$field
            fi

            if [ $index -eq 5 ]; then
                read_section_count=$field
            fi

            if [ $index -eq 7 ]; then
                write_count=$field
            fi

            if [ $index -eq 9 ]; then
                write_section_count=$field
            fi

            index=$((index+1))
        done

        partition_name=${partition_name_list[$partition_index]}
        tmp=$((read_count - last_${partition_name}_read_count))
        echo "Partition: $partition_name"
        echo "The number of read completed in $time_elapsed is $tmp, $(($tmp / $time_elapsed)) /s"
        tmp=$((read_section_count - last_${partition_name}_read_section_count))
        tmp_size=$(($tmp * $sector_size))
        echo "The number of sectors read in $time_elapsed is $tmp (size: $tmp_size Byte), $(($tmp_size / $time_elapsed)) Byte/s"
        tmp=$((write_count - last_${partition_name}_write_count))
        echo "The number of write completed in $time_elapsed is $tmp, $(($tmp / $time_elapsed)) /s"
        tmp=$((write_section_count - last_${partition_name}_write_section_count))
        tmp_size=$(($tmp * $sector_size))
        echo "The number of sectors write in $time_elapsed is $tmp (size: $tmp_size Byte), $(($tmp_size / $time_elapsed)) Byte/s"

        eval last_${partition_name}_read_count=$read_count
        eval last_${partition_name}_read_section_count=$read_section_count
        eval last_${partition_name}_write_count=$write_count
        eval last_${partition_name}_write_section_count=$write_section_count
        partition_index=$(($partition_index + 1))
    done
    echo "================================================================"
    last_parsed_time=$parsed_time
}

while [ 1 -eq 1 ]
do
    parse_partitions
    sleep 10
done
