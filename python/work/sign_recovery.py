#! /usr/bin/env python
#-*- coding:utf-8 -*-

import os
import commands
import sys
import shutil
import getpass
import time
import zipfile
import string
import errno
import getopt

TMPDIR = 'tmp'
UNPACKTOOL = 'split_boot'
BOOT_ARGS = ""

def usage():
    print "sign_recovery -i recovery.img -o recovery-release.img xx.x509.pem jj.x509.pem ..."
    sys.exit(1)

def mkdir(path):
    try:
        os.mkdir(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            shutil.rmtree(path)
            os.mkdir(path)
        else:
            raise

def copy_file(src, target):
    if (os.path.isdir(src)):
        if (not os.path.exists(target)):
            mkdir(target)
        for subitem in os.listdir(src) :
            copy_file(os.path.join(src, subitem), os.path.join(target, subitem))
    elif (os.path.islink(src)):
        linkto = os.readlink(src)
        os.symlink(linkto, target)
    elif (os.path.isfile(src)):
        if (os.path.isdir(target)):
            target = os.path.join(target, os.path.basename(src))
        file_in = open(src, 'r')
        file_out = open(target, 'w')
        file_out.writelines(file_in.readlines())
        file_out.flush()
        file_out.close()
    else:
        print "Unknown file %s" % (src)

def generage_keys(keys):
    DUMPFILE = "./dumpkey.jar"
    raw_keys = ""
    for info in  os.popen('java -jar %s %s' % (DUMPFILE, keys)).readlines():
        raw_keys = raw_keys + info
    return raw_keys

def unpack_recovery(file):
    global BOOT_ARGS
    if os.path.exists(TMPDIR):
        shutil.rmtree(TMPDIR, True)
    mkdir(TMPDIR)
    copy_file(file, TMPDIR)
    copy_file(UNPACKTOOL, TMPDIR)
    for info in os.popen('cd %s; perl %s %s; cd -' % (TMPDIR, UNPACKTOOL, file)):
        pairs = info.split(':')
        pairs_key = pairs[0]
        pairs_value = pairs[-1]
        if (pairs_key == 'Page size'):
            towrite = pairs_value[:pairs_value.index('(')].strip() + ' '
            BOOT_ARGS = BOOT_ARGS + '--pagesize ' + towrite
        if (pairs_key == 'Command line'):
            towrite = pairs_value.split("'")[1]
            towrite = "".join(filter(lambda x: x in string.printable, towrite)) # filter out invisible characters
            if (len(towrite) != 0):
                towrite = towrite
                BOOT_ARGS = BOOT_ARGS + '--cmdline ' + '"%s"' % (towrite) + ' '
        if (pairs[0] == 'Base address'):
            towrite = pairs_value[pairs_value.index('(')+1:pairs_value.rindex(')')] + ' '
            BOOT_ARGS = BOOT_ARGS + '--base ' + towrite

    #return os.path.splitext(file)[0]
    return file

def repack_recovery(ramdisk, kernel, output):
    os.popen('./mkbootfs %s | ./minigzip > newramdisk.cpio.gz' % (ramdisk))
    print './mkbootimg --kernel %s %s --ramdisk newramdisk.cpio.gz -o %s' % (kernel, BOOT_ARGS, output)
    os.popen('./mkbootimg --kernel %s %s --ramdisk newramdisk.cpio.gz -o %s'
             % (kernel, BOOT_ARGS, output))
    shutil.rmtree(TMPDIR, True)
    os.unlink('newramdisk.cpio.gz')

def update_keys(recovery_path, keys):
    key_file = open(recovery_path + '/res/keys', 'w')
    key_file.write(keys)
    key_file.close()

def parse_argvs(argv):
    input = ""
    output = ""
    keys = ""

    if len(argv) < 3:
        usage()
        return (input, output, keys)

    shortargs = 'i:o:'
    longargs = ['input=', 'output=']
    opts, args = getopt.getopt(argv, shortargs, longargs)
    for opt, val in opts:
        if opt in ('-i', '--input'):
            input = val
        if opt in ('-o', '--output'):
            output = val
    for key in args:
        keys = keys + key + ' '

    return (input, output, keys)

def main(argv):
    input, output, keys = parse_argvs(argv)

    if not input or not output or not keys:
        print "Missing input file / output file / keys"
        sys.exit(1)

    raw_key = generage_keys(keys)
    print "new key: " + raw_key
    prefix_name = unpack_recovery(input)
    recovery_ram_path = os.path.join(TMPDIR, prefix_name + '-ramdisk')
    recovery_kernel_path = os.path.join(TMPDIR, prefix_name + '-kernel.gz')
    update_keys(recovery_ram_path, raw_key)
    repack_recovery(recovery_ram_path, recovery_kernel_path, output)

if __name__ == "__main__":
    main(sys.argv[1:])
