#! /usr/bin/env python

from ctypes import *
libc = CDLL("/lib/x86_64-linux-gnu/libc-2.19.so")
message_string = "Hello World!\n"
libc.printf("Testing: %s", message_string);
