#! /usr/bin/env python

import os
import sys
import urllib
import socket

repo_cfg_file = "/work/COS/repo.cfg"
repo_dict = {}
repo_src_dir = "/work/COS/"
build_script_list = ['build.elite1000.sh', 'buildp2.sh', 'build.sh', 'build.jscn.sh']

def check_connection(url):
    proto, rest = urlib.splittype(url)
    host,rest = urllib.splithost(rest)
    host, port = urllib.splitport(host)

    if port is None:
        port = 443              # TCP

    ipaddress = socket.gethostbyname(host)

    # check connection
    s = socket.socket()
    try:
        s.connect((ipaddress, port))
        print "Connected to %s on port %s" % (address, port)
        return True
    except socket.error, e:
        print "Connection to %s on port %s failed: %s" % (ipaddress, port, e)
        return False

def repo_cfg_parser(file) :
    if (not os.path.exists(file)) :
        print "[E] no cfg file(%s) found\n" % (file)

    cfg = open(file, 'r')
    for line in cfg.readlines() :
        if line.startswith('#'):
            continue
        print line.split('==>')
        key,value = line.split('==>');
        repo_dict[key] = value

def repo_sync(path, cmd) :
    sync_cmd = ''
    if (cmd.startswith("repo")):
        sync_cmd = 'cd %s; repo forall -c "git checkout ."; repo forall -c "git clean -df"; repo sync; repo start master --all' % (path)
    elif (cmd.startswith("git")):
        sync_cmd = 'cd %s; git pull' % (path)
    else :
        print "[E] unknown VC"

    print sync_cmd
    for line in os.popen(sync_cmd).readlines():
        print line

def repo_create(path, cmd) :
    os.mkdir(path)
    create_cmd = ''
    if (cmd.endswith("\n")):
        cmd = cmd[:-1]
    if (cmd.startswith("repo")) :
        create_cmd = "cd %s; %s" % (path, cmd)
    elif (cmd.startswith("git")) :
        create_cmd = "%s %s" % (cmd, path)

    print create_cmd
    for line in os.popen(create_cmd).readlines() :
        print line
    repo_sync(path, cmd)

def repo_update(cfg, src_dir) :
    for key, value in repo_dict.items() :
        target_dir = os.path.join(src_dir, key)
        i = value.find('@')
        if (i == -1) :
            i = value.find('://')

        if (os.path.exists(target_dir)) :
            repo_sync(target_dir, value)
        else:
            repo_create(target_dir, value)

def repo_build(cfg, src_dir):
    for key, value in repo_dict.items():
        target_dir = os.path.join(src_dir, key)
        if (os.path.exists(target_dir)):
            run_build_command(target_dir)

def run_build_command(target_dir):
    build_cmd = ''
    cmds = ''
    for script in build_script_list:
        path = target_dir + "/" + script
        print path
        if (os.path.exists(path)):
            cmds = script
    build_cmd = "cd %s; ./%s clean_build" % (target_dir, cmds)
    print build_cmd
    for line in os.popen(build_cmd).readlines() :
        print line,

if __name__ == '__main__' :
    # update env PATH, so that it can find repo
    os.environ["PATH"] = (os.path.abspath("/home/werther/bin/") + os.pathsep + os.environ["PATH"])
    repo_cfg_parser(repo_cfg_file)
    repo_update(repo_dict, repo_src_dir)
    repo_build(repo_dict, repo_src_dir)
