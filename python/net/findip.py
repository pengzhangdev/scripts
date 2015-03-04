#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
import os,time,sys,multiprocessing,random

# python3 support, httplib renamed to http.client in python3
if sys.version_info >= (3, 0):
    import http.client
else:
    import httplib

# good google's ip [elapse time, ip]
ip_queue=multiprocessing.Queue()

# need about approximate number of ips, program will stop itself?
ip_max_need=250
 
# how many ip parallelly check?, one ip one threadper.
thread_number=50

# store good ip
google_ip=[]

def iplookup(ip,q):
    """ Check google's ip is suitable for goagent. """
    try:
        # python3 will use http.client.HTTPSConnection
        if sys.version_info >= (3, 0):
            conn=http.client.HTTPSConnection(ip,timeout=2)
        else:
            conn=httplib.HTTPSConnection(ip,timeout=2)

        conn.request("GET", "/")
        st=time.time()
        response=conn.getresponse()
        en=time.time()
        result=str(response.status)+' '+response.reason
        if '200 OK' in result:
            # read page
            html_content=response.read(300).decode("utf-8", "ignore")
            # check page title
            check_ans=html_content.find('<title>Google</title>')
            if check_ans!=-1:          
                q.put([en-st, ip])
        conn.close()
    except:
        pass

def deal_ip(google_ip):
    """ Get, arrange and format ipfor goagent. """
    # sort [elapse_time, ip] with eclapse_time
    arranged_ip=sorted(google_ip,key=lambda l:l[0])
    
    # format ip for goagent
    format_ip="|".join([ip[1] for ip in arranged_ip])

    # print arranged good ip, fast ahead
    if format_ip:
        print("\r\nOutput, total good IPs: %d\r\n" % len(arranged_ip))
        print(format_ip)
        print("\r\nPlease wait about 3 minutes to use goagent!!!\r\n"+\
            "I don't know why, but the scanning does affect it.\r\n"+\
            "You may have a cup of coffee, ^_^\r\n"+\
            "Enjoy!")
        write_file=open('out.txt', 'w')
        write_file.write(format_ip+'\r\n')
        write_file.close()
    else:
        print("\r\nI am sorry, nothing found out")
        print("You may need to rerun it, and wait for it more time.")


def show_progress(ips, thread_number):
    """ show something to terminal """
    # print scanning content to terminal
    format_str="\rScan: {:>8}.x.x, {:>3} IPs, "
    format_str=format_str.format(".".join(ips[0].split('.')[0:-2]),
        thread_number)
    print(format_str,end='')
    # show progress and elapse time
    good_ips=len(google_ip)
    print("good IPs: %d, " % good_ips,end='')
    progress=int(float(good_ips)/ip_max_need*100)
    print("progress: %d%%, " % progress,end='')
    time_elapse=int(time.time()-program_st)
    print("elapse: %ds" % time_elapse,end='')

def sys_exit():
    """ system exit() """
    # windows system, leave cmd window unclosed.
    if sys.platform == "win32" or sys.platform == "win64":
        os.system("pause")
    else:
        sys.exit(0)



if __name__ == '__main__':

    # get all files in ./ippool
    ippool_files=["./ippool/%s" % s for s in os.listdir("./ippool")]

    # record program start time, used to calculate elapse time
    program_st=time.time()
    try:
        # read all ips to lines
        lines=[]
        for ip_file in ippool_files:
            # open file
            with open(ip_file, 'r') as infile:
                lines.extend(infile.readlines())                       
                # close opened file
                infile.close()

        # split text to list with '\n' end
        lines=[x.rstrip('\n') for x in lines]
        # split ip to 2d array every tread_number
        ip_all=[lines[i:i+thread_number] for i in range(0,len(lines),
                    thread_number)]

        # sort ip_all randomly
        ip_all=sorted(ip_all, key=lambda *args: random.random())
        
        for ips in ip_all:
            # show something to terminal
            show_progress(ips, thread_number)

            # python multiprocessing
            procs=[]
            for ip in ips:
                p = multiprocessing.Process(target=iplookup,
                                            args=(ip,ip_queue,))
                procs.append(p)
                p.daemon=True
                p.start()

            for p in procs:
                p.join(4)
                if p.is_alive():
                    p.terminate() 
                    
            # get all suitable ip in ip_queue
            while not ip_queue.empty():
                try:
                    google_ip.append(ip_queue.get())
                except:
                    pass

            # break when it reach approximate ips
            if len(google_ip)>=ip_max_need:
                # update the content of terminal
                show_progress(ips, thread_number)

                print("\r\nIPs reached needs.")
                break
             
        # finished all ip scanning, I need deal with found ip
        deal_ip(google_ip)
        # exit
        sys_exit()

    except KeyboardInterrupt:
        # when user pressed Ctrl+C, I need to deal with found ip
        deal_ip(google_ip)
        # exit
        sys_exit()
        
