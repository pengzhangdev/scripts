#! /usr/bin/python

import os
import sys

repo_cfg_file = "./repo.cfg"
repo_dict = {}
repo_src_dir = "./src/"

def repo_cfg_parser(file) :
    if (not os.path.exists(file)) :
        print "[E] no cfg file(%s) found\n" % (file)

    cfg = open(file, 'r')
    for line in cfg.readlines() :
        key,value = line.split('==>');
        repo_dict[key] = value

def repo_sync(path, cmd) :
    sync_cmd = ''
    if (cmd.startswith("repo")):
        sync_cmd = 'cd %s; repo sync' % (path)
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
        if (os.path.exists(target_dir)) :
            repo_sync(target_dir, value)
        else:
            repo_create(target_dir, value)

if __name__ == '__main__' :
    repo_cfg_parser(repo_cfg_file)
    repo_update(repo_dict, repo_src_dir)
