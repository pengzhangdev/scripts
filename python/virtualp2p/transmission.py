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

import os
import sys

# date format:
# heartbeat:     05 05 00
# tcp request:   05 01 00 03(name) xx(name len) [name in ascii] xx xx(port)
#                05 01 00 01(ipaddr) xx xx xx xx(ip in ascii) xx xx(port)
# udp request:   05 03 00 03(name) xx(name len) [name in ascii] xx xx(port)
#                05 03 00 01(ipaddr) xx xx xx xx(ip in ascii) xx xx(port)
# on init:
#  ==> local
# 1. create control channel to relay server
# 2. create local listener


#  ==> local
# 1. request remote server to get a unique virtual ip address
# 2. map the name to the socket accepted before
#  ==> service
# 1. 

# closure
def make_transform_func_list(isLocal):
    private_data = [""]
    transform_mapper = {}
    listener_socket = None
    def trans_init(name):
        # init as client if it is local
        # or server if remote server
        pass

    def recv_handler():
        # recv data
        # if local
        # socket is the listener
        # 1. add to mapper
        # socket is a client
        # 1. bypass the message according the mapper
        # if server
        # 1. add to listener loop and waiting for connecting meta data
        # 2. parse the meta data and 
        pass

    

    def transform_add_mapper(socket1, socket2):
        transform_mapper[socket1] = socket2
        transform_mapper[socket2] = socket1

    
