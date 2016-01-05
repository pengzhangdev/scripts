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

from urllib import urlopen
import os
import sys

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
        file = urlopen(option_page)
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
    return options_summary
    print "==> Done"
    file.close()

def main(argv):
    print compiler_ther
option_summary()


if __name__ == '__main__':
    main(sys.argv[1:])
