#! /usr/bin/env python

#
# shell.py ---
#
# Filename: shell.py
# Description: shell model to parse input args and print outputs
# Author: Werther Zhang
# Maintainer: zzd
# Created: Sat Nov  7 17:38:19 2015 (+0800)
#

# Change Log:
#
#

from __future__ import absolute_import, division, print_function, \
    with_statement

import os
import json
import sys
import getopt
import logging

verbose = 0

def check_python():
    info = sys.version_info
    if info[0] == 2 and not info[1] >= 6:
        print('Python 2.6+ required')
        sys.exit(1)
    elif info[0] == 3 and not info[1] >= 3:
        print('Python 3.3+ required')
        sys.exit(1)
    elif info[0] not in [2, 3]:
        print('Python version not supported')
        sys.exit(1)

def print_exception(e):
    global verbose
    logging.error(e)
    if verbose > 0:
        import traceback
        traceback.print_exc()

def usage(docs):
    print (docs.rstrip('\n'))

def parse_options(argv,
                  docstring,
                  extra_opts="", extra_long_opts=(),
                  extra_option_handler=None):
    """parse the options. docsting is the help if parsing error or got
    -h for help.extra_opts and extra_long_opts are for flags defined by
    caller, which are processed by passing them to extra_option_handler"""

    try:
        opts, args = getopt.getopt(
            argv, "hv" + extra_opts,
            ["help", "verbose"] + list(extra_long_opts))
    except getopt.GetoptError, err:
        usage(docstring)
        print_exception(err)
        sys.exit(2)

    for o, a in opts:
        if o in ("-h", "--help"):
            usage(docstring)
            sys.exit()
        if o in ("-v", "--verbose"):
            global verbose
            verbose = 1
        else:
            if extra_option_handler is None or not extra_option_handler(o, a):
                print ("Unknown options \"%s\" "  % (o))

    return args


if __name__ == "__main__":
    # test
    def option_handler(o, a):
        if o in ("-f", "--file"):
            print (a);
        elif o in ("-i", "--include"):
            print (a);
        else:
            return False
        return True

    args = parse_options(sys.argv[1:], "help",
                         extra_opts = "f:i:",
                         extra_long_opts = ["file=",
                                          "include="
                                          ],
                         extra_option_handler = option_handler)
    if len(args) != 1:
        usage("aa")
    print(args)
