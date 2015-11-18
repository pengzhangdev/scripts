#! /usr/bin/env python
#
# transmission.py ---
#
# Filename: transmission.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Wed Nov 18 12:19:49 2015 (+0800)
#

# Change Log:
#
#

# date format:
# heartbeat:     05 05 00
# tcp request:   05 01 00 03(name) xx(name len) [name in ascii]
#                05 01 00 01(ipaddr) xx xx xx xx
# udp request:   05 03 00 03(name) xx(name len) [name in ascii]
#                05 03 00 01(ipaddr) xx xx xx xx

# closure
def make_transform_func_list(sender, recver):
    private_data = [""]
    def trans_init(name, ):
        pass
