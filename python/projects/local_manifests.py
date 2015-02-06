#! /usr/bin/python2.7

import xml.dom

#
# Create local manifests in .repo for android source code to
# replace the origin aosp project, because no access to googlesource.
#

class RepoManifest(object):
    def __init__(self):
        self.path=""
        self.name=""
        self.groups=""
        self.revision=""
        self.remote=""

    def setPath(path):
        self.path=path

    def setName(name):
        self.name=name

    def setGroups(groups):
        self.groups=groups

    def setRevision(revision):
        self.revision=revision

    def setRemote(remote):
        self.remote=remote

def generateProperty(node):
    NamedNodeMap attrs = node.getAttribute()
    for attr in attrs :
        print attr.name attr.localName attr.value

def getNextNode(node):
    return node.nextSibling

def getPrevNode(node):
    return node.previousSibling

def getParentNode(node):
    return node.parentNode

def getChild(node):
    if (node.hasChildNodes()):
        return node.firstChild
    return None


