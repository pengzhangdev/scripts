#! /usr/bin/env python

import socket
import sys
import os

class TCPServer(object):
    """
    Local TCPServer, recv connect request and create tcp connection to comminucate
    """
    def __init__(self, host, port): # (char, int)
        self.__host = host
        self.__port = port
        self.__socket = None
        self.__loop = None

    def get_socket(self):
        return self.__socket

    def handle(self, socket):   # check type(POLL_IN/OUT/ERR) also
        if socket == self.__socket:
            pass
        conn, addr = socket.accept()
        if conn is None:
            return None

        # new WebSocketClient to remote WebSocketService
        wsc = None
        tc = TCPConnection(conn, wsc)
        wsc.add_buddy(tc)       # if wsc is closed, call TCPConnection to close
        wsc.start()             # Not implemented
        tc.add_loop(self.__loop) # If tc is closed, call WebSocketClient close

    def add_loop(self, loop):   # (EventLoop)
        self.__loop = loop
        self.__loop.add_loop(self.__socket, self.handle)

class TCPConnection(object):
    """
    Local tcp connection, transfer data to endport
    """

    def __init__(self, socket, buddy):
        self.__socket = socket  # accepted socket
        self.__buddy = buddy

    def handle(self, socket):
        if self.__socket != socket:
            return None
        data = socket.recv()
        self.__buddy.send(data)

    def send(self, data):
        self.__socket.sendall(data)

    def close(self):
        self.__socket.close()
        self.__buddy = None

    def add_loop(self, loop):
        loop.add_loop(self.__socket, self.handle)
