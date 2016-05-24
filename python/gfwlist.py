#! /usr/bin/env python
#
# gfwlist.py ---
#
# Filename: gfwlist.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Tue May 24 10:46:47 2016 (+0800)
#

# Change Log:
#
#

GFWLIST_URL = "https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt"

import os;
import sys;
import base64;

from urllib2 import urlopen

class GfwList:
    def __init__(self, url):
        self.__url = url;
        self.__contents = "";
        self.__decoded = False;

    def __download(self):
        try:
            file = urlopen(self.__url, timeout = 20)
        except IOError:
            print "Maybe Network Error"
            sys.exit(-1);
        except Exception:
            raise Exception;
        self.__contents = file.read();
    def __decode(self):
        self.__contents = base64.b64decode(self.__contents)
        self.__decoded = True

    def __rmDuplicate(self, list):
        return reduce(lambda x,y: x if y in x else x + [y], [[],] + list)

    def init(self):
        self.__download();
        self.__decode();

    def dumpToMiRouter(self, fname):
        if self.__decoded == False:
            print "GfwList is not ready"
            return ;
        outbuf = [] ;
        for line in self.__contents.split('\n'):
            if line.find('General List End') != -1:
                break;
            if line.startswith('['):
                continue;
            if line.startswith('!'):
                continue;
            if line.startswith('||'):
                outbuf = outbuf + [line[2:] + '\n']
                continue;
            if line.startswith('|h'):
                continue;
            if line.startswith('@@'):
                continue;
            if line.startswith('.'):
                outbuf = outbuf + [line + '\n']
            if line.startswith('/^'):
                if line.find('google') != -1:
                    start = line.index('google') + 9
                    end = line.index(')', start);
                    for sub in  line[start:end].split('|'):
                        outbuf = outbuf + ['.google.' + sub + '\n'];
                else:
                    print line
                continue
            if len(outbuf) != 0:
                outbuf = outbuf + [line + '\n']

        outbuf = self.__rmDuplicate(outbuf);
        outbuf = "".join(outbuf);
        outbuf = outbuf + "facebook.com" + '\n'
        outbuf = outbuf + ".facebook.com" + '\n'
        outbuf = outbuf + ".blogspot.com" + '\n'
        outbuf = outbuf + '.blogspot.net' + '\n'

        f = open(fname, 'w')
        f.write(outbuf)
        f.close()


def main(argv):
    gfw = GfwList(GFWLIST_URL)
    gfw.init()
    gfw.dumpToMiRouter("/tmp/mirouter_gfwlist.txt")

if __name__ == '__main__' :
    main(sys.argv);
