#! /usr/bin/python

##################################################################
##      Author:         pengzhang                               ##
##      email:          pengzhangdev@gmail.com                  ##
##      date:           2014-12-04                              ##
##      version:        0.0.01                                  ##
##################################################################

##################################################################
##    * This script parses the config file and download         ##
##      VC code in target dir                                   ##
##    * config file:                                            ##
##      dirname==>VC command                                    ##
##      android==>repo init -u https://android.goo....          ##
##      kernel==>git clone ...                                  ##
##   *  If the url is not reachable, the script fastsshproxy    ##
##      will run, wich start a ssh tunnel and using             ##
##      proxychains to forward the requests                     ##
##   *  TODO:                                                   ##
##      +  If target dir is exists, the program should get      ##
##         the url and check whether it is matched to config    ##
##         file. If not, clean the target dir and download      ##
##################################################################

import os
import sys
import shutil
import urllib
import socket
import subprocess
import time
import getopt
import pexpect

repo_cfg_file = "./repo.cfg"
repo_dict = {}
repo_src_dir = "./src/"

def repo_start_proxy_server():
    cmd = "fastsshproxy start"
    print cmd
    ssh = pexpect.spawn(cmd)
    r = ''
    try:
        index = ssh.expect(['password: ', '.continue connecting (yes/no)?'])
        if index == 0:
            ssh.sendline('fastssh.com')
        elif index == 1:
            ssh.sendline('yes')
    except pexpect.EOF:
        ssh.close()
    else:
        r = ssh.read()
        ssh.expect(pexpect.EOF)
        ssh.close()
    return r

def repo_check_server(cmd):
    index = cmd.find('://')
    start = cmd.rfind(' ', 0, index)
    end = cmd.find(' ', start + 1);
    if end == -1:
        end = len(cmd)

    # got url
    url = cmd[start:end]
    # username, we treat it as lan network
    if (url.find('@') != -1):
        return True

    protocol, rest = urllib.splittype(url)
    host, rest = urllib.splithost(rest)
    host, port = urllib.splitport(host)
    if port is None:
        port = 443              # TCP port
    print host
    ipaddr = socket.gethostbyname(host)
    s = socket.socket()
    try:
        s.connect((ipaddr, port))
    except socket.error, erval:
        (errno, err_msg) = erval
        print "Connect server failed %d (%s)" % (errno, err_msg)
        return False

    return True

def repo_cfg_parser(file) :
    if (not os.path.exists(file)) :
        print "[E] no cfg file(%s) found\n" % (file)

    cfg = open(file, 'r')
    for line in cfg.readlines() :
        key,value = line.split('==>');
        repo_dict[key] = value

def repo_sync(path, cmd) :
    proxy = 0
    sync_cmd = ''
    if (cmd.startswith("repo")):
        sync_cmd = 'repo sync'
    elif (cmd.startswith("git")):
        sync_cmd = 'git pull'
    else :
        print "[E] unknown VC"
        return False

    if not repo_check_server(cmd):
        repo_start_proxy_server()
        sync_cmd = 'fastsshproxy ' + sync_cmd
        proxy = 1

    sync_cmd = 'cd %s; %s' % (path, sync_cmd)

    print sync_cmd
    p = subprocess.Popen(sync_cmd, stdin = subprocess.PIPE,
                         #stdout = subprocess.PIPE,
                         #stderr = subprocess.STDOUT, 
                         shell=True)
    time.sleep(3)
    #print p.stdout.read()
    p.communicate()
    #print pout
    # while True:
    #     buff = p.stdout.readline()
    #     if buff == '' and p.poll() != None:
    #         break
    #     print buff


    # for line in os.popen(sync_cmd).readlines():
    #     print line

def repo_create(path, cmd) :
    os.mkdir(path)
    create_cmd = ''
    cmd_new = ''
    proxy = 0
    if (cmd.endswith("\n")):
        cmd_new = cmd[:-1]
    if not repo_check_server(cmd) : # call proxy to download
        repo_start_proxy_server()
        cmd_new = "fastsshproxy " + cmd_new;
        proxy = 1

    if (cmd.startswith("repo")) :
        create_cmd = "cd %s; %s" % (path, cmd_new)
    elif (cmd.startswith("git")) :
        create_cmd = "%s %s" % (cmd_new, path)

    print create_cmd
    p = subprocess.Popen(create_cmd, stdin = subprocess.PIPE,
                         #stdout = subprocess.PIPE,
                         #stderr = subprocess.STDOUT, 
                         shell=True)
    time.sleep(3)
    # if proxy == 1:
    #     p.stdin.write("fastssh.com")
    #print p.stdout.read()
    p.communicate()
    #print pout
    # while True:
    #     buff = p.stdout.readline()
    #     if buff == '' and p.poll() != None:
    #         break
    #     print buff

    repo_sync(path, cmd)

def repo_update(cfg, src_dir) :
    for key, value in repo_dict.items() :
        target_dir = os.path.join(src_dir, key)

        if (os.path.exists(target_dir)) :
            repo_sync(target_dir, value)
        else:
            repo_create(target_dir, value)

    # remove unused dirs
    dirlist = os.listdir(repo_src_dir)
    for dir in dirlist:
        if (os.path.isdir(os.path.join(repo_src_dir, dir))):
            if not repo_dict.has_key(dir):
                shutil.rmtree(os.path.join(repo_src_dir, dir))

def usage(program):
    print "%s usage:" % program
    print "-h, --help         : print help message"
    print "-c, --cfg          : pass config file"
    print "-d, --directory    : the directory for source code to download"

def main(argc, argv):
    global repo_cfg_file
    global repo_src_dir
    try :
        opts, args = getopt.getopt(argv[1:], 'hc:d:', ['cfg=', 'directory='])
    except getopt.GetoptError, err:
        print str(err)
        usage(argv[0])
        sys.exit(2)
    # print args
    for o, a in opts:
        if o in ('-h', '--help'):
            usage(argv[0])
            sys.exit(1)
        elif o in ('-c', '--cfg'):
            print a
            repo_cfg_file = a
        elif o in ('-d', '--directory'):
            print a
            repo_src_dir = a
    repo_cfg_parser(repo_cfg_file)
    repo_update(repo_dict, repo_src_dir)

if __name__ == '__main__' :
    main(len(sys.argv), sys.argv)
    # repo_cfg_parser(repo_cfg_file)
    # repo_update(repo_dict, repo_src_dir)
