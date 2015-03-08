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
import threading
import random

# python3 support, httplib renamed to http.client in python3
if sys.version_info >= (3, 0):
    import http.client
else:
    import httplib

def ip_lookup(ip, q, t):
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
        q.put([0, "0.0.0.0"])

def ip_random_search(list, q, t):
    random_list = sorted(list, key = lambda *args : random.random())
    for ip in random_list:
        # multiprocessing to speed up ?
        ip_lookup(ip, q, t)

class IPNotifier(threading.Thread):
    """ Notify to start fetch IP every 15 minus """
    __IDLE_TIME = 15 * 60
    def __init__(self, condition):
        self.con = condition

    def run(self):
        time.sleep(self.__IDLE_TIME)
        self.con.notify()

class GoogleIP(threading.Thread):
    """ A thread class to fetch available google ips
    And Goagent can get the fastest ip from stored list.
    The loop is running to update the list and search for
    more IPs.
    """
    __IPPOOL = ""
    __NSL_CMD = "nslookup -q=TXT _netblocks.google.com 8.8.8.8"
    __IDLE_TIME = 15 * 60 # seconds
    __GOOGLE_IP_FILENAME = "google_ip.txt"

    def __init__(self):
        super(GoogleIP, self).__init__(name = self.__name__)
        # the elements of google_ip_list is (est, ip)
        # multithread read/write
        # There is a thread check all ips and remove invalid ones and search
        # for more available IPs event @__IDLE_TIME
        # And also, goagent main module get IP from google_ip_list.
        self.google_ip_list = []
        # the elements of process_list is multiprocessing.Process
        self.process_list = []
        # google ip filepath
        self.google_ip_filepath = self.getCurrentFilePath()
        # message queue
        self.message_queue = multiprocessing.Queue()
        # random_ip_list
        self.random_ip_list = self.getRandomIPList()
        # lock
        self.lock = threading.Lock()
        # thread status
        # 0 : stop
        # 1 : idle
        # 2 : working
        # 3 : cancel
        self.status = 0
        # condition
        self.con = threading.Condition()
        # notifier
        self.notifier = IPNotifier(self.con)

    def getRandomIPList(self):
        ip_list = []
        return ip_list

    def getCurrentFilePath(self):
        global __file__
        __file__ = os.path.abspath(__file__)
        if os.path.islink(__file__):
            __file__ = getattr(os, 'readlink', lambda x: x)(__file__)
        dirname = os.path.dirname(os.path.abspath(__file__))
        return dirname + self.__GOOGLE_IP_FILENAME

    def exit(self):
        """ Call exit before program quit to terminate all process and save ip list """
        for p in self.process_list:
            if (p.is_alive()):
                p.terminate()

        write_file = open(self.google_ip_filepath)
        for ip_set in self.google_ip_list:
            write.write(ip_set[1] + '\t' + ip_set[0] + '\r\n')
        write_file.close()

    def checkGoogleIP(self):
        for ip_set in google_ip_list:
            p = multiprocessing.Process(target = ip_lookup,
                                        args = (ip_set[1],
                                                self.message_queue,
                                                ip_set[0] * 2))
            self.process_list.append(p)
            p.start()

        # for p in self.process_list:
        #     p.join(4)
        #     if (p.is_alive()):
        #         p.terminate()

        # self.lock.aquire()
        # self.google_ip_list = []
        # self.lock.release()
        # while not self.message_queue.empty():
        #     try:
        #         self.lock.aquire()
        #         self.google_ip_list.append(self.message_queue.get())
        #         self.lock.release()
        #     except:
        #         pass

    def searchGoogleIP(self, ip):
        p = multiprocessing.Process(target = ip_lookup,
                                    args = (ip, self.message_queue,2))
        self.process_list.append(p)
        p.start()

    def getIP(self):
        """ get a avaiable google ip """
        while (len(self.google_ip_list) == 0):
            if (self.status == 2):
                continue
            if (self.status == 1):
                # notify thread start, we'd better using Conditiion instead
                pass
        return self.google_ip_list[0][1]

        if (len(self.google_ip_list) == 0):
            # for i in range(0, 10):
            #     p = multiprocessing.Process(target = ip_random_search,
            #                                 args = (self.random_ip_list,
            #                                       self.message_queue,
            #                                       2))
            #     self.process_list.append(p)
            # Notify a thread to start to search ip address
            pass
        else:
            # p = multiprocessing.Process(target = ip_random_search,
            #                             args = (self.random_ip_list,
            #                                     self.message_queue,
            #                                     2))
            # self.process_list.append(p)
            # Notify a thread to start to search ip address
            for ip_set in google_ip_list:
                p = multiprocessing.Process(target = ip_lookup,
                                            args = (ip_set[1],
                                                    self.message_queue,
                                                    ip_set[0] * 2))
                self.process_list.append(p)
                p.start()

        while self.message_queue.empty():
            continue
        valid_ip = ""
        try:
            valid_ip = message_queue.get()[1]
        except:
            pass
        for p in self.process_list:
            if (p.is_alive()):
                p.terminate()

        if (valid_ip == ""):
            return None
        return valid_ip

    def run(self):
        # start check google_ip_list and fetch random available ip
        # appending to google_ip_list

        # check google_ip_list
        self.checkGoogleIP()
        self.random_ip_list = sorted(self.random_ip_list, key = lambda *args : random.random())
        index = 0
        for index in range(0, 11):
            self.searchGoogleIP(self.random_ip_list[index])

        self.lock.aquire()
        self.google_ip_list = []
        self.lock.release()
        while (self.google_ip_list.size() < 20):
            if (self.message_queue.empty()):
                continue;
            try:
                obj = self.message_queue.get()
                if (obj[1] != "0.0.0.0"):
                    self.google_ip_list.append(obj)
                  
            except:
                pass
