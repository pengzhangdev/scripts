#! /usr/bin/env python
#
# flask_websockets.py ---
#
# Filename: flask_websockets.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Wed Jun 29 12:53:02 2016 (+0800)
#

# Change Log:
#
#



# manage.py

from geventwebsocket.handler import WebSocketHandler
from gevent.pywsgi import WSGIServer
from flask import Flask, request, render_template, abort
from geventwebsocket import WebSocketError


class MessageServer(object):

    def __init__(self):
        self.observers = []

    def add_message(self, msg):
        for ws in self.observers:
            try:
                ws.send(msg)
            except WebSocketError:
                self.observers.pop(self.observers.index(ws))
                print ws, 'is closed'
                continue

msgsrv = MessageServer()

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('message.html')


@app.route('/message/')
def message():
    if request.environ.get('wsgi.websocket'):
        ws = request.environ['wsgi.websocket']
        msgsrv.observers.append(ws)
        while True:
            if ws.socket:
                message = ws.receive()
                if message:
                    msgsrv.add_message("%s" % message)
            else:
                abort(404)
    return "Connected!"


if __name__ == '__main__':
    http_server = WSGIServer(('', 5000), app, handler_class=WebSocketHandler)
    http_server.serve_forever()
