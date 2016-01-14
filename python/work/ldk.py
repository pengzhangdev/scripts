#! /usr/bin/env python2
#
# ldk.py ---
#
# Filename: ldk.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Fri Dec  4 13:13:06 2015 (+0800)
#

# Change Log:
#
#

from urllib2 import urlopen
import os
import sys

OPTIONS = {}
GLOBAL_SDK_PATH = ""

def compiler_option_parse_line(line):
    start = 0
    end = 0
    options_summary = []
    while True:
        start = line.find(' -', start)
        if start == -1:
            break

        start = start + 1
        end1 = line.find('=', start)
        end2 = line.find(' ', start)
        if end1 == -1 and end2 != -1:
            end = end2
        if end1 != -1 and end2 == -1:
            end = end1
        if end1 == -1 and end2 == -1:
            end = len(line)
        if end1 != -1 and end2 != -1:
            end = min(end1, end2)
        if end == len(line):
            option = line[start:]
        else:
            option = line[start:end]
        if option.find('<var>') != -1:
            i = option.find('<var>')
            option = option[:i]
        if option.endswith('\n'):
            option = option[:-1]
        options_summary.append(option)

    return options_summary

def compiler_option_summary():
    option_page = "https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html"
    local_page = "Option_Summary.html"
    options_summary = []
    print "==> Generating compiler options from gnu online docs"
    try:
        file = urlopen(option_page, timeout = 10)
    except IOError:
        file = open(local_page)
    except Exception:
        raise Exception
    index = 0
    hit = 0
    for line in file.readlines():
        if hit == 0 and line.find('<pre class="smallexample">') != -1:
            index = index + 1
            hit = 1
        if hit == 1:
            options_summary = options_summary + compiler_option_parse_line(line)
        if hit == 1 and line.find('</pre>') != -1:
            hit = 0
    print "==> Done options"
    file.close()
    return options_summary

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

def show_commands(path):
    buffer = []
    copy_file(path, path+'.bak')
    r = open(path, 'r')
    for line in r.readlines():
        pos = line.find('make')
        if pos == -1:
            buffer.append(line)
            continue
        buffer.append(line[0:pos + 4] + ' -n ' + line[pos + 4:])
    r.close()
    w = open(path, 'w')
    w.writelines(buffer)

def run_compiler(sdk_path):
    modules = ('libtest', 'libtest_static', 'CaTest')
    compile_cmd = 'cd app-build/build/; ./autopackage.sh %s app_name=%s  sdk_root_rel=%s' # %('clean', module, sdk_path)
    compile_buffer = []
    show_commands('app-build/build/autopackage.sh')
    for module in modules:
        os.popen(compile_cmd % ('clean', module, sdk_path)).readlines()
        compile_buffer = compile_buffer + os.popen(compile_cmd % ('', module, sdk_path)).readlines()
    copy_file('app-build/build/autopackage.sh.bak', 'app-build/build/autopackage.sh')
    return compile_buffer

def split_args(line):
    start = 0
    end = 0
    options = []
    while True:
        start = line.find(' -', start)
        if start == -1:
            break
        start = start + 1
        end = line.find(' ', start)
        if end == -1:
            end = len(line)
        elif line[start:end] == '-I' or line[start:end] == '-include':
            end = line.find(' ', end + 1)
        if end == len(line):
            option = line[start:]
        else:
            option = line[start:end]
        if option.endswith('\n'):
            option = option[:-1]
        options.append(option)
    return options

def match_toolchain(line):
    global OPTIONS
    gpp = 'arm-linux-androideabi-g++'
    gcc = 'arm-linux-androideabi-gcc'
    ar = 'arm-linux-androideabi-ar'
    hit_gpp = line.find(gpp)
    hit_gcc = line.find(gcc)
    if hit_gpp != -1 :
        OPTIONS["g++"] = (refine_path(line.split(" ")[0]), "")
        OPTIONS["ar"] =(OPTIONS["g++"][0][:-3] + "ar", "")
        return True
    if hit_gcc != -1 :
        OPTIONS["gcc"] = (refine_path(line.split(" ")[0]), "")
        OPTIONS["ar"] = (OPTIONS["gcc"][0][:-3] + "ar", "")
        return True

    return False

def rm_duplicate(list):
    return reduce(lambda x,y: x if y in x else x + [y], [[],] + list)

def refine_path(flag):
    global GLOBAL_SDK_PATH
    sdk_abs_path = os.path.abspath(GLOBAL_SDK_PATH)
    wd = os.path.dirname(sdk_abs_path)
    sdk_name = os.path.basename(sdk_abs_path)

    prefix_end = flag.find(wd)
    prefix = flag[:prefix_end]
    start = len(wd) + len(prefix)
    if prefix.startswith('-I') and flag.find('bionic') == -1:
        return None
    if prefix.startswith('-L') and flag.find('%s/lib' % (sdk_name)) == -1:
        return None
    if prefix.startswith('-Wl,-rpath-link') and flag.find('%s/lib' % (sdk_name)) == -1:
        return None

    if flag.find(sdk_name) == -1 :
        return None

    return prefix + "${COS_SDK_PATH}" + flag[start:]

def refine_flags(flags, summary, whitelist, blacklist):
    out = []
    ignored = []
    unknown = []
    for flag in flags:
        hit_black = False
        hit_white = False

        if flag.startswith('-I') or flag.startswith('-include') or \
           flag.startswith('-L') or flag.startswith('-Wl,-rpath-link'):
            i_flag = refine_path(flag)
            if i_flag == None:
                ignored.append(flag)
            else:
                out.append(i_flag)
            continue
        for black in blacklist:
            if black.endswith('*'):
                if flag.startswith(black[:-1]):
                    ignored.append(flag)
                    hit_black = True
                    break
            else:
                if flag == black:
                    ignored.append(flag)
                    hit_black = True
                    break

        if hit_black:
            continue

        if flag in summary:
            out.append(flag)
            continue

        for white in whitelist:
            if white.startswith('*'):
                if flag.endswith(white[1:]):
                    out.append(refine_path(flag))
                    hit_white = True
                    break
            elif flag in whitelist:
                out.append(refine_path(flag))
                hit_white = True
                break

        if hit_white:
            continue

        hit = False
        for option in summary:
            if flag.startswith(option):
                out.append(flag)
                hit = True
                break
        if hit :
            continue
        else :
            unknown.append(flag)

    return (out, ignored, unknown)

def get_android_binary_list(line):
    opt = []
    for item in line.split():
        if item.endswith('.so'):
            opt.append(item)
        if item.endswith('.o'):
            opt.append(item)
        if item.endswith('.a'):
            opt.append(item)

    return opt

def parse_compiler_args(args):
    cflags_sym = 'echo "target thumb C:'
    ldflags_sym = 'echo "target SharedLib:'
    arflags_sym = 'echo "target StaticLib:'
    exeflags_sym = 'echo "target Executable:'
    hit_cflags = False
    hit_ldflags = False
    hit_arflags = False
    hit_exeflags = False
    cflags = []
    ldflags = []
    arflags = []
    exeflags = []
    for line in args:
        if hit_cflags :
            if match_toolchain(line):
                cflags = cflags + split_args(line)
                hit_cflags = False
        if hit_ldflags :
            if match_toolchain(line):
                ldflags = ldflags + split_args(line) + get_android_binary_list(line)
                hit_ldflags = False
        if hit_arflags :
            if match_toolchain(line):
                arflags = arflags + split_args(line) + get_android_binary_list(line)
                hit_arflags = False
        if hit_exeflags:
            if match_toolchain(line):
                exeflags = exeflags + split_args(line) + get_android_binary_list(line)
                hit_exeflags = False
        if line.startswith(cflags_sym):
            hit_cflags = True
        if line.startswith(ldflags_sym):
            hit_ldflags = True
        if line.startswith(arflags_sym):
            hit_arflags = True
        if line.startswith(exeflags_sym):
            hit_exeflags = True
        match_toolchain(line)
    return (rm_duplicate(cflags), rm_duplicate(ldflags), ["crsP"], rm_duplicate(exeflags))

def format_flags(flags):
    buffer = ""
    for str in flags:
        if str != None:
            buffer = buffer + '\t' + str + ' \\\n'
    return buffer


def generate_makefile(sdk_path):
    global OPTIONS
    path_prefix = os.path.dirname(os.path.abspath(sdk_path)) + '/'
    mk = open('ldk.mk', 'w')
    buffer = ""
    buffer = buffer + 'COS_SDK_PATH := %s\n' % (path_prefix)
    buffer = buffer + 'COS_GCC := %s\n' % (OPTIONS["gcc"][0])
    buffer = buffer + 'COS_GXX := %s\n' % (OPTIONS["g++"][0])
    buffer = buffer + 'COS_AR  := %s\n' % (OPTIONS["ar"][0])
    buffer = buffer + '\n'
    buffer = buffer + 'COS_CFLAGS := \\\n'
    buffer = buffer + format_flags(OPTIONS["cflags"][0])
    buffer = buffer + '\nCOS_SHAREDLIBRARIES_LDFLAGS := \\\n'
    buffer = buffer + format_flags(OPTIONS["ldflags"][0])
    buffer = buffer + '\nCOS_EXECUTABLE_LDFLAGS := \\\n'
    buffer = buffer + format_flags(OPTIONS["exeflags"][0])
    buffer = buffer + '\nCOS_AR_FLAGS := \\\n'
    buffer = buffer + format_flags(OPTIONS["arflags"][0])
    #print buffer
    mk.write(buffer)
    mk.close()

def main(argv):
    global GLOBAL_SDK_PATH
    blacklist=['-c', '-S', '-E', '-o', '-D*', '-Os', '-g', '-U*', '-Wl,-soname,*', '-l*']
    whitelist=['-fno-exceptions', '-fno-short-enums', '-Wno-unused', '-fno-strict-aliasing',
               '-W', '*libgcc.a', '*crtend_so.o', '*crtend_android.o', '*crtbegin_dynamic.o',
               '*crtbegin_so.o']
    GLOBAL_SDK_PATH = argv[0]
    sdk_path = os.path.abspath(argv[0])
    option_summary = compiler_option_summary()
    (cflags, ldflags, arflags, exeflags) = parse_compiler_args(run_compiler(sdk_path))

    OPTIONS["cflags"] = refine_flags(cflags, option_summary, whitelist, blacklist)
    OPTIONS["ldflags"] = refine_flags(ldflags, option_summary, whitelist, blacklist)
    OPTIONS["exeflags"] = refine_flags(exeflags, option_summary, whitelist, blacklist)
    OPTIONS["arflags"] = (arflags, "", "")
    
    generate_makefile(GLOBAL_SDK_PATH)
    # for key in OPTIONS:
    #     print key + " :"
    #     print OPTIONS[key][0]

if __name__ == '__main__':
    main(sys.argv[1:])
