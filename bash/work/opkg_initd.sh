#! /bin/sh /etc/rc.common
#
# mirouter_initd.sh ---
#
# Filename: mirouter_initd.sh
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Fri Mar 25 16:13:15 2016 (+0800)
#

# Change Log:
#
#
waiting_and_get_ext_storage_mountpoint() {
    while true
    do
        tmp=`mount | grep extdisks/`
        if [ -z "$tmp" ]
        then
            sleep 1
        else
            echo `echo $tmp | cut -d ' ' -f 3`
            break
        fi
    done
}

start() {
    external_path=$(waiting_and_get_ext_storage_mountpoint)
    export LD_LIBRARY_PATH="$external_path/opkg/lib:$external_path/opkg/usr/lib"
    for f in `ls $external_path/opkg/init.d/`
    do
        $external_path/opkg/init.d/$f start $external_path
    done
}

stop() {
    external_path=$(waiting_and_get_ext_storage_mountpoint)
    export LD_LIBRARY_PATH="$external_path/opkg/lib:$external_path/opkg/usr/lib"
    for f in `ls $external_path/opkg/init.d/`
    do
        $external_path/opkg/init.d/$f stop $external_path
    done
}

restart() {
    external_path=$(waiting_and_get_ext_storage_mountpoint)
    export LD_LIBRARY_PATH="$external_path/opkg/lib:$external_path/opkg/usr/lib"
    for f in `ls $external_path/opkg/init.d/`
    do
        $external_path/opkg/init.d/$f restart $external_path
    done
}

