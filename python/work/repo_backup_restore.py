#! /usr/bin/env python
#
# repo_backup_restore.py ---
#
# Filename: repo_backup_restore.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Mon May 22 14:51:50 2017 (+0800)
#

# Change Log:
#
#
import sys
import os

repo_dict = dict()

def parse_config_file(config_file):
    """return url and branch 
    if branch is None, no -b """
    

def main(argc, argv):
    if argc != 2:
        print("Usage: xx [dir]")

    dirname = argv[1]
    dirList = []
    for f in os.listdir(dirname):
        if (os.path.isdir(path + '/' + f)):
            if(f[0] == '.'):
                pass
            else:
                dirList.append(f)
    config_file = dirname + '/' + f + '/' + ".repo/manifests/.git/config"
    

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)
