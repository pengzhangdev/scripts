#! /usr/bin/env python
#
# sudoku.py ---
#
# Filename: sudoku.py
# Description:
# Author: Werther Zhang
# Maintainer:
# Created: Mon Nov 23 16:05:58 2015 (+0800)
#

# Change Log:
#
#

import sys
import os

def update_column(pos):
    pass

def update_row(pos):
    pass

def update_partner(pos):
    pass

def is_column_legal(pos):
    pass

def is_row_legal(pos):
    pass

def get_partner(pos):
    # return 9x9 empty box
    pass

def get_row(pos):
    pass

def get_column(pos):
    pass

# get the cases by case_in_row & case_in_column & case_in_box
def case_in_row(pos):
    # return 'B00000000'
    pass

def case_in_column(pos):
    # return 'B00000010'
    pass

def case_in_box(pos):
    # return 'B0000010'
    pass


def process_sudoku(decode, path):
    sudoku = [[0 for col in range(9)] for row in range(9)] # 9x9
    
    def read():
        f = open(path, 'r')
        sudoku = f.read().split()
        return sudoku[0]

    def printf():
        print sudoku[0]

    return (read, printf)

class Sudoku(object):
    def __init__(self):
        self.__sudoku = [[0 for col in range(9)] for row in range(9)] # 9x9
        self.__case_list = []

    def read(self, path):
        f = open(path, 'r')
        self.sudoku = f.read().split()

    def __count_bit_1(self, num):
        count = 0
        while num > 0:
            num = num & (num - 1)
            count = count + 1
        return count

    def __get_case_for_column(self, pos):
        pass

    def __get_case_for_row(self, pos):
        pass

    def __get_case_in_box(self, pos):
        pass

    def __get_case(self, pos):
        for i in range(0, 9):
            for j in range(0, 9):
                tmp = self.__sudoku[i][j]
                pos = (i, j)
                if tmp > 0:
                    self.__sudoku = -tmp
                if tmp == '*':
                    self.__sudoku[i][j] = (__get_case_in_box(pos)
                                         & __get_case_for_row(pos)
                                         & __get_case_in_box(pos)
                    
        return (__get_case_in_box(pos)
                & __get_case_for_row(pos)
                & __get_case_in_box(pos))

    def __pre_init():
        pass

    def decode():
        pass

    def dump(self):
        print self.sudoku


def main(argv):
    sudoku = Sudoku()
    sudoku.read(argv[0])
    sudoku.decode()
    sudoku.dump()

if __name__ == "__main__":
    main(sys.argv[1:])
