#! /usr/bin/env python
#-*-coding:utf-8-*-
#
# rextester.py ---
#
# Filename: rextester.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Wed Apr 19 10:42:57 2017 (+0800)
#

# Change Log:
#
#

import urllib2
import urllib
import httplib


programdata='''import os
import sys
import json

print("Hello World")'''

url = "http://rextester.com/rundotnet/Run"
postdata = {
    'LanguageChoiceWrapper':5,
    'EditorChoiceWrapper':1,
    'Program':programdata,
    'Input':"",
    'Privacy':"",
    'PrivacyUsers':"",
    'Title':"",
    'SavedOutput':"",
    'WholeError':"",
    'WholeWarning':"",
    'StatsToSave':"",
    'CodeGuid':"",
    'IsInEditMode': False,
    'IsLive': False
}

header={
    'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'
}

postdata = urllib.urlencode(postdata)
conn = httplib.HTTPConnection("rextester.com")
conn.request(method="POST", url=url, body=postdata, headers=header)
response = conn.getresponse()
res= response.read()
conn.close()
print res
