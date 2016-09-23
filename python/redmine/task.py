#! /usr/bin/env python
#-*- coding:utf-8 -*-
#
# task.py ---
#
# Filename: task.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Tue Sep 20 13:22:17 2016 (+0800)
#

# Change Log:
#
#
# unicode symbol ⌚ ⚠

from redmine import Redmine
import sys
import os

redmine = Redmine('http://10.27.254.102:8000', key='8b217ca86a76bad41d35494dbefa8ad37c45bde7')

user = redmine.user.get("current")

my_issues = redmine.issue.filter(status_id = "open", assigned_to_id = "me");

def redmine_get_name(obj, attr):
    return getattr(getattr(obj, attr, None), "name", "")

def redmine_get_id(obj, attr):
    return getattr(getattr(obj, attr, None), "id", -1)

for issue in my_issues:
    if getattr(getattr(issue, u'tracker', None), 'name', "") == u"资产":
        continue

    if getattr(getattr(issue, "status", None), "name", "") == u"FIXIMPLEMENTED" or \
       getattr(getattr(issue, "status", None), "name", "") == u"WONTFIX" or\
       getattr(getattr(issue, "status", None), "name", "") == u"DUPLICATE":
        continue

    tracker = getattr(getattr(issue, u'tracker', None), 'name', "")
    subject = getattr(issue, "subject", "")
    status = getattr(getattr(issue, "status", None), "name", "")
    start_date = getattr(issue, "start_date", "")
    due_date = getattr(issue, "due_date", "")
    priority = redmine_get_name(issue, "priority")

    print(u"issue: [%s] %s status %s priority %s start: %s due: %s   ⌚ ⚠ "
          % (tracker, subject, status, priority, start_date, due_date))

    # for item in issue:
    #     print("{}".format(item))


if __name__ == '__main__':
    pass
    #main(sys.argv)
