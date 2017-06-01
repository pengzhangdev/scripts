#! /bin/bash
#
# network_watchdog.sh ---
#
# Filename: network_watchdog.sh
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Thu Jun  1 14:20:01 2017 (+0800)
#

# Change Log:
#
#

function networkCheck()
{
    timeout=5
    target=www.baidu.com
    ret_code=`curl -I -s --connect-timeout $timeout $target -w %{http_code} | tail -n1`
    if [ "x$ret_code" = "x200" ]; then
        echo "network ok"
    else
        echo "network error"
    fi
}

while [ 1 -eq 1 ]
do
    networkCheck
    sleep 900
done
