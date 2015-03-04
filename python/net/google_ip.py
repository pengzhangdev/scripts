#!/usr/bin/env python
# -*- coding: utf-8 -*-

#    This file is modified from findip.py

#    This program is free software: you can redistribute it
#    and/or modify it under the terms of the GNU General Public
#    License as published by the Free Software Foundation, either
#    version 3 of the License, or (at your option) any later
#    version. This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY; without even the
#    implied warranty of MERCHANTABILITY or FITNESS FOR A
#    PARTICULAR PURPOSE. See the GNU General Public License for
#    more details. You should have received a copy of the GNU
#    General Public License along with this program. If not, see
#    http://www.gnu.org/licenses/.

from __future__ import print_function
import os
import time
import sys
import multiprocessing
import random

# python3 support, httplib renamed to http.client in python3
if sys.version_info >= (3, 0):
    import http.client
else:
    import httplib

def iplookup(ip, q, t):
    """ Check google's ip is suitable for goagent """
    try:
        if sys.version_info >= (3, 0):
            conn = http.client.HTTPSConnection(ip, timeout=t)
        else:
            conn = httplib.HTTPSConnection(ip, timeout=t)

        conn.request("GET", "/")
        st = time.time()
        response = conn.getresponse()
        et = time.time()
        result = str(response.status) + ' ' + response.reason
        if '200 OK' in result:
            # read page
            html_content = response.read(300).decode("utf-8", "ignore")
            # check title
            check_ack = html_content.find('<title>Google</title>')
            if (check_ack != -1) :
                q.put([et - st, ip])
        conn.close()
    except:
        pass

class GooglIP(object):
    IPPOOL = ""
    NSL_CMD = "nslookup -q=TXT _netblocks.google.com 8.8.8.8"
    IDLE_TIME = 15 * 60 # seconds
    GOOGLE_IP_FILENAME = "google_ip.txt"

    def __init__(self):
        
