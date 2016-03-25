#! /bin/sh
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
command=$1

waiting_and_get_ext_storage_mountpoint() {
    while true
    do
        tmp=`mount | grep extdisk`
        if [ -z "$tmp" ]
        then
            sleep 1
        else
            arr=$(tmp)
            echo ${arr[3]}
            return ${arr[3]}
        fi
    done
}

start() {
    external_path=$(waiting_and_get_ext_storage_mountpoint)
    for f in `ls $external_path/opkg/init.d/`
    do
        $external_path/opkg/init.d/$f start $external_path
    done
}

stop() {
    external_path=$(waiting_and_get_ext_storage_mountpoint)
    for f in `ls $external_path/opkg/init.d/`
    do
        $external_path/opkg/init.d/$f stop $external_path
    done
}

restart() {
    external_path=$(waiting_and_get_ext_storage_mountpoint)
    for f in `ls $external_path/opkg/init.d/`
    do
        $external_path/opkg/init.d/$f restart $external_path
    done
}

case $command in
    (start)
        start
        ;;
    (stop)
        stop
        ;;
    (restart)
        restart
        ;;
    (*)
        ;;
esac
