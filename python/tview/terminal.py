#! /usr/bin/env python
#
# terminal.py ---
#
# Filename: terminal.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Wed Sep 21 10:34:11 2016 (+0800)
#

# Change Log:
#
#

import curses
import traceback
import hashlib

class Terminal(object):
    Terminal.COLOR_BLACK = 0
    Terminal.COLOR_RED = 1
    Terminal.COLOR_GREEN = 2
    Terminal.COLOR_YELLOW = 3
    Terminal.COLOR_BLUE = 4
    Terminal.COLOR_MAGENTA = 5
    Terminal.COLOR_CYAN = 6
    Terminal.COLOR_WHITE = 7

    #http://ironalbatross.net/wiki/index.php?title=Python_Curses
    def __init__(self):
        self.screen = curses.initscr()
        # Turn off echoing of keys, and enter cbreak mode,
        # where no buffering is performed on keyboard input
        curses.noecho()
        curses.cbreak()
        curses.start_color()
        self.screen.keypad(1)
        self.disply_contents = []

    def restore_terminal(self):
        # called on main loop exception to enable traceback
        self.screen.keypad(0)
        curses.echo()
        curses.nocbreak()
        curses.endwin()

    def is_dirty(self, contents):
        origin = hashlib.sha1(','.join(self.disply_contents)).hexdigest()
        new = hashlib.sha1(','.join(contents)).hexdigest()
        return (not (origin == new))

    def __draw_line(self, width, y):
        for x in range(width):
            self.screen.addch(y, x, curses.ACS_HLINE)

    def display(cotents):
        self.display_contents = contents
        self.screen.erase()
         for (index,line,) in enumerate(self.display_contents):
             line = self.display_contents[index]
             height, width = self.screen.getmaxyx()
             y = line + 10
             x = (width - len(line)) / 2
             self.__draw_line(width, y - 1)
             self.screen.addstr(y, x, line)

def test(t):
    t.resize

if __name__ == '__main__':
    t = Terminal()
    try:
        test(t)
    except:
        t.restore_terminal()
        traceback.print_exc()
