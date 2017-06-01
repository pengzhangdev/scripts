#! /usr/bin/env python
#
# parser.py ---
#
# Filename: parser.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Tue May 16 11:04:29 2017 (+0800)
#

# Change Log:
#
#

import matplotlib.pyplot as plt
import numpy as np
import time
import dateutil
import sys
import os

class DiskIOEntry:
    """Disk IO Entry"""
    def __init__(self, partition):
        self.__partition = partition
        self.__readSize = 0
        self.__writeSize = 0
        self.__seconds = 0
        self.__writeSpeed = 0

    def setReadSize(self, size):
        """byte"""
        self.__readSize = size

    def setWriteSize(self, size):
        """byte"""
        self.__writeSize = size

    def setTime(self, timestr, starttime):
        """seconds"""
        datetime_struct = dateutil.parser.parse(timestr)
        timestring = datetime_struct.strftime('%Y-%m-%d %H:%M:%S')
        self.__seconds = int(time.mktime(time.strptime(timestring, '%Y-%m-%d %H:%M:%S'))) - starttime

    def setWriteSpeed(self, speed):
        """ Byte/s"""
        self.__writeSpeed = speed

    def getPartitionName(self):
        return self.__partition

    def getTimestamp(self):
        return self.__seconds

    def getReadSize(self):
        return self.__readSize

    def getWriteSize(self):
        return self.__writeSize

    def getWriteSpeed(self):
        return self.__writeSpeed

    def dump(self):
        print("Partition: {}".format(self.__partition))
        print("ReadSize: {}".format(self.__readSize))
        print("WriteSize: {}".format(self.__writeSize))
        print("Seconds: {}".format(self.__seconds))
        print("WriteSpeed: {}".format(self.__writeSpeed))

class PartitionList:
    def __init__(self):
        self.__partitionList = dict()

    def addDiskIOEntry(self, partition, entry):
        if self.__partitionList.has_key(partition):
            pass
        else:
            self.__partitionList[partition] = list()
        self.__partitionList[partition].append(entry)

    def getEntryList(self, partition):
        return self.__partitionList.get(partition)

    def getEntryPartitions(self):
        return self.__partitionList.keys()



def diskio_parser(filename, partitionList):
    """"""
    buff = ""
    with open(filename) as f:
        buff = f.readlines()

    diskentry = None
    readsize = 0
    writesize = 0
    timestring = ""
    starttime = 0
    for line in buff:
        if line.find("time elapsed") != -1:
            if timestring == "":
                timestring = line.split("========")[0]
            else:
                print("timestring not reset")
                sys.exit(1)
            if starttime == 0:
                datetime_struct = dateutil.parser.parse(timestring)
                timestr = datetime_struct.strftime('%Y-%m-%d %H:%M:%S')
                starttime = int(time.mktime(time.strptime(timestr, '%Y-%m-%d %H:%M:%S')))

        if line.startswith("entry :"):
            if readsize == 0:
                readsize = line.split(' ')[14]
            else:
                print("readSize not reset")
                sys.exit(1)

            if writesize == 0:
                writesize = line.split(' ')[18]
            else:
                print("writeSize not reset")
                sys.exit(1)

        if line.startswith("Partition:"):
            if diskentry != None:
                print("diskentry not none")
                sys.exit(1)
            partition = line.split(' ')[1]
            diskentry = DiskIOEntry(partition[:-1])
            diskentry.setReadSize(int(readsize) * 512)
            diskentry.setWriteSize(int(writesize) * 512)
            diskentry.setTime(timestring, starttime)
            readsize = 0
            writesize = 0

        if line.startswith("The number of sectors write in"):
            speed = line.split(' ')[-2]
            diskentry.setWriteSpeed(speed)
            #diskentry.dump()
            partitionList.addDiskIOEntry(diskentry.getPartitionName(), diskentry)
            diskentry = None
            #sys.exit(1)

        if line.startswith("=================="):
            timestring = ""

def toChart(partitionList):
    for partition in partitionList.getEntryPartitions():
        entryList = partitionList.getEntryList(partition)
        sortedEntryList = sorted(entryList, key=lambda d : d.getTimestamp())

        fileName = "{}_writeSize.png".format(partition)
        X = [ e.getTimestamp() for e in sortedEntryList ]
        Y = [ e.getWriteSize() for e in sortedEntryList ]
        #print("writeSize {}".format(Y))
        plt.figure(figsize=(50,20))
        plt.plot(X, Y, "b-", linewidth=1)
        plt.xlabel("Time Elapsed (s)")
        plt.ylabel("Size (byte)")
        plt.ylim(0, Y[-1])
        plt.title("The Write Size of {}".format(partition))
        plt.savefig(fileName)

        fileName = "{}_readSize.png".format(partition)
        X = [ e.getTimestamp() for e in sortedEntryList ]
        Y = [ e.getReadSize() for e in sortedEntryList ]
        plt.figure(figsize=(50,20))
        plt.plot(X, Y, "b-", linewidth=1)
        plt.xlabel("Time Elapsed (s)")
        plt.ylabel("Size (byte)")
        plt.title("The Read Size of {}".format(partition))
        plt.savefig(fileName)

        fileName = "{}_writeSpeed.png".format(partition)
        X = [ e.getTimestamp() for e in sortedEntryList ]
        Y = [ e.getWriteSpeed() for e in sortedEntryList ]
        plt.figure(figsize=(50,20))
        plt.plot(X, Y, "b-", linewidth=1)
        plt.xlabel("Time Elapsed (s)")
        plt.ylabel("Size (byte)")
        plt.title("The Write Speed of {}".format(partition))
        plt.savefig(fileName)

        sortedEntryList[-1].dump()

def main(argc, argv):
    filename = argv[1]
    partitionList = PartitionList()
    diskio_parser(filename, partitionList)
    toChart(partitionList)

if __name__ == '__main__':
    main(len(sys.argv), sys.argv)










