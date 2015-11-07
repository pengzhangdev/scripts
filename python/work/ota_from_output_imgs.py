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
from zipfile import *

info_map = {}
fs_tools={'emmc':'unpack-bootimg.pl',
          'nand':'unpack-bootimg.pl',
          'ext4':'simg2img',
          'yaffs2':'un_yaffs2'}

cfg_dirs = {'BOOT':'boot',
            'OTA':'ota',
            'META':'meta',
            'RECOVERY':'recovery',
            'RADIO':'radio'}

GPrebuildImagePath = "BOOTABLE_IMAGES"

def mkdir(path):
    try:
        os.mkdir(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            shutil.rmtree(path)
            os.mkdir(path)
        else:
            raise

def dump_info_map() :
    for i in info_map :
        print i,"==>",info_map[i]

def copy_file(src, target):
    print "copy %s ==> %s" % (src, target)
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

def build_boot(key, value) :
    boot_file = value[0]
    boot_type = value[-1]
    shutil.rmtree(key, True)
    mkdir(key)
    mkdir(os.path.join(key,'RAMDISK'))
    copy_file(cfg_dirs[key], key)
    mkdir('tmp')
    copy_file(info_map[key][0], 'tmp/%s' % (info_map[key][0]))
    copy_file('releasetools/unpack-bootimg.pl', 'tmp/unpack-bootimg.pl')

    for info in os.popen('cd tmp; perl unpack-bootimg.pl %s; cd -' % (info_map[key][0])).readlines() :
        print info,
        pairs = info.split(':')
        pairs_key = pairs[0]
        pairs_value = pairs[-1]
        if (pairs_key == 'Page size'):
            towrite = pairs_value[:pairs_value.index('(')].strip() + '\n'
            f = open(os.path.join(key, 'pagesize'), 'w')
            f.write(towrite);
            f.flush()
            f.close()
        if (pairs_key == 'Command line'):
            #print "pair %s ==> %d : %d" % (pairs_value, pairs_value.index('\'')+1, pairs_value.rindex('\''))
            #towrite = pairs_value[pairs_value.index('\'')+1:pairs_value.rindex('\'')]
            towrite = pairs_value.split("'")[1]
            towrite = "".join(filter(lambda x: x in string.printable, towrite)) # filter out invisible characters
            #print "towrite %s ==> %d" % (towrite, len(towrite))
            if (len(towrite) != 0):
                towrite = towrite + '\n'
                f = open(os.path.join(key, 'cmdline'), 'w')
                f.write(towrite);
                f.flush()
                f.close()
        if (pairs[0] == 'Base address'):
            towrite = pairs_value[pairs_value.index('(')+1:pairs_value.rindex(')')] + '\n'
            f = open(os.path.join(key, 'base'), 'w')
            f.write(towrite)
            f.flush()
            f.close()

    copy_file('tmp/%s-ramdisk' % (info_map[key][0]), os.path.join(key, 'RAMDISK'))
    copy_file('tmp/%s-kernel.gz' % (info_map[key][0]), os.path.join(key, 'kernel'))
    if (os.path.exists('%s/misc_info.txt' % (os.path.join(key, 'RAMDISK')))) :
        if (os.path.exists('META')):
            copy_file('%s/misc_info.txt' % (os.path.join(key, 'RAMDISK')), 'META')
        else:
            copy_file('%s/misc_info.txt' % (os.path.join(key, 'RAMDISK')), 'meta')

    shutil.rmtree('tmp', True)

def build_ext4_img(key, value):
    imgtools = fs_tools[value[1]]
    print "imgtools ==>" + imgtools
    target_file = value[0] + '.img'
    command = 'releasetools/%s %s %s' % (imgtools, value[0], target_file)
    print command
    status, outputinfo = commands.getstatusoutput(command)
    print outputinfo
#    for info in os.popen(command).readlines() :
#        print info,

    if (status != 0) :
        print "Failed to %s %s, retry to mount %s directly" % (imgtools, value[0], value[0])
        os.remove(target_file)
        target_file = value[0]

    status, outputinfo = commands.getstatusoutput('mount %s tmp -o loop' % (target_file))
    print outputinfo
#    for info in os.popen('mount %s tmp -o loop' % (target_file)):
#        print info

    if (status != 0) :
        print "ERROR: failed to mount system image, target otapackage won't contain system files"
        shutil.rmtree('tmp', True)
        os.abort()

    copy_file('tmp', key)

    for info in os.popen('umount tmp'):
        print info

    if (target_file != value[0]) :
        os.remove(target_file)

def build_yaffs2_img(key, value):
    #print key, value
    imgtools = fs_tools[value[1]]
    print "imgtools ==> " + imgtools
    copy_file(info_map[key][0], 'tmp/%s' % (info_map[key][0]))
    copy_file('releasetools/un_yaffs2', 'tmp/un_yaffs2')
    for info in os.popen('cd tmp; chmod 0755 un_yaffs2; ./un_yaffs2 %s; cd -' % (info_map[key][0])).readlines() :
        print info

    os.remove('tmp/un_yaffs2')
    os.remove('tmp/%s' % (info_map[key][0]))
    copy_file('tmp', key)

def build_system(key, value):
    mkdir('tmp')
    shutil.rmtree(key, True)
    mkdir(key)

    if (len(value) < 2):
        # No image
        return

    if (value[1] == 'ext4'):
        build_ext4_img(key, value)
    if (value[1] == 'yaffs2'):
        build_yaffs2_img(key, value)

    shutil.rmtree('tmp', True)

def build_raw(key, value):
    shutil.rmtree(key, True);
    mkdir(key)
    if (value[0] == ''):
        copy_file(cfg_dirs[key], key)
    else:
        copy_file(value[0], key)

def zip_add_dir(file, dir):
    print "add %s to %s" % (dir, file)
    z = zipfile.ZipFile(file, 'a', zipfile.ZIP_DEFLATED)
    z.write(dir)
    for dirpath, dirnames, filenames in os.walk(dir):
        #  Failed to add dir symbol link
        for dirname in dirnames:
            if os.path.islink(os.path.join(dirpath, dirname)):
                attr = zipfile.ZipInfo()
                attr.filename = os.path.join(dirpath, dirname)
                attr.create_system = 3
                #attr.external_attr = 2716663808L
                attr.external_attr = 2717843456L
                z.writestr(attr, os.readlink(os.path.join(dirpath, dirname)))
            else:
                z.write(os.path.join(dirpath, dirname))
        for filename in filenames:
            if os.path.islink(os.path.join(dirpath, filename)):
                attr = zipfile.ZipInfo()
                attr.filename = os.path.join(dirpath, filename)
                attr.create_system = 3
                #attr.external_attr = 2716663808L
                attr.external_attr = 2717843456L
                z.writestr(attr, os.readlink(os.path.join(dirpath, filename)))
            else:
                z.write(os.path.join(dirpath, filename))
    z.close();

def create_ota_target_file():
    time_now = time.strftime('%Y-%m-%d',time.localtime(time.time()))
    user = getpass.getuser()
    ota_target_file = 'ota_taget_file_%s_%s.zip' % (user, time_now)

    if (os.path.exists(ota_target_file)):
        os.remove(ota_target_file)

    print "Create zip file"
    if (os.path.exists(GPrebuildImagePath)):
        zip_add_dir(ota_target_file, GPrebuildImagePath)
        shutil.rmtree(GPrebuildImagePath)

    for dir in info_map:
        if (os.path.exists(dir)):
            zip_add_dir(ota_target_file, dir)
            shutil.rmtree(dir)
        else:
            print "No %s found, maybe we have add it to zip because it is a subdir of some one" % (dir)

    # update meta info
    for info in os.popen('zipinfo -1 %s | awk \'BEGIN { FS="SYSTEM/" } /^SYSTEM\// {print "system/" $2}\' | releasetools/fs_config > meta/filesystem_config.txt' % (ota_target_file)).readlines() :
        print info,

    for info in os.popen('zipinfo -1 %s | awk \'BEGIN { FS="BOOT/RAMDISK/" } /^BOOT\/RAMDISK\// {print $2}\' | releasetools/fs_config > meta/boot_filesystem_config.txt' % (ota_target_file)).readlines() :
        print info,

    for info in os.popen('zipinfo -1 %s | awk \'BEGIN { FS="RECOVERY/RAMDISK/" } /^RECOVERY\/RAMDISK\// {print $2}\' | releasetools/fs_config > meta/recovery_filesystem_config.txt' % (ota_target_file)).readlines() :
        print info,

    # update filesystem config
    z = zipfile.ZipFile(ota_target_file, 'a', zipfile.ZIP_DEFLATED)
    z.write('meta/filesystem_config.txt', 'META/filesystem_config.txt')
    z.write('meta/boot_filesystem_config.txt', 'META/boot_filesystem_config.txt')
    z.write('meta/recovery_filesystem_config.txt', 'META/recovery_filesystem_config.txt')

    os.remove('meta/filesystem_config.txt')
    os.remove('meta/boot_filesystem_config.txt')
    os.remove('meta/recovery_filesystem_config.txt')

def create_prebuild_images(key, value):
    prebuildImageName = ''

    if (key == 'BOOT'):
        prebuildImageName = "boot.img"
    if (key == 'RECOVERY'):
        prebuildImageName = "recovery.img"

    # force boot/recovery image prebuld
    # if (len(value) < 3):
    #     return

    # if (value[2] != 'prebuild'):
    #     return

    if (not os.path.exists(GPrebuildImagePath)):
        mkdir(GPrebuildImagePath)
    target = GPrebuildImagePath + "/" + prebuildImageName
    if (os.access(target, os.F_OK)):
        os.remove(target)
    copy_file(value[0], target)

# main start here

info_path = ""

if (os.path.exists("ota_info.txt")):
    info_path = "ota_info.txt"
elif (os.path.exists("info.txt")):
    info_path = "info.txt"
else:
    print "No ota_info.txt or info.txt found, Abort!!"
    os.abort();

info_f = open(info_path, 'r')
for line in info_f :
    key = line[:-1].split(':')[0]
    value = line[:-1].split(':')[1:]
    info_map[key] = value

dump_info_map()

if not any(info_map):           # check whether info_map is empty
    print "No available info in ota_info.txt or info.txt"
    os.abort()

info_map_scanner = info_map.iteritems();
for key, value in info_map_scanner:
    if (key == 'BOOT'):
        build_boot(key, value)
        create_prebuild_images(key, value)
    if (key == 'RECOVERY'):
        build_boot(key, value)
        create_prebuild_images(key, value)
    elif (key == 'SYSTEM'):
        build_system(key, value)
    elif (key == 'DATA'):
        build_system(key, value)
    elif (key == 'OTA'):
        build_raw(key, value)
    elif (key == 'META'):
        build_raw(key, value)
    elif (key == 'RADIO'):
        build_raw(key, value)
    elif (key.startswith('SYSTEM')):
        build_system(key, value);

create_ota_target_file()
