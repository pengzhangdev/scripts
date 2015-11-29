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
import math

class Sudoku(object):
    def __init__(self):
        self.__sudoku = [[0 for col in range(9)] for row in range(9)] # 9x9
        self.__case_list = []
        self.__steps = []

    def read(self, path):
        f = open(path, 'r')
        items = f.read().split()
        for i in range(0, 9):
            for j in range(0, 9):
                self.__sudoku[i][j] = items[9 * i + j]

    def __count_bit_1(self, num):
        count = 0
        while num > 0:
            num = num & (num - 1)
            count = count + 1
        return count

    def __get_last_bit_1(self, num):
        if num == 0:
            return 0
        i = ~num
        return (int(math.log(num & i)/(math.log(2))) + 1)

    def __get_case_for_column(self, pos):
        case = 0b111111111
        i = pos[0]
        for j in range(0, 9):
            cell = self.__sudoku[i][j]
            if cell < 0:
                case = case & ~(1 << (-int(cell) - 1))
        return case

    def __get_case_for_row(self, pos):
        case = 0b111111111
        j = pos[1]
        for i in range(0, 9):
            cell = self.__sudoku[i][i]
            if cell < 0:
                case = case & ~(1 << (-int(cell) - 1))
        return case

    def __get_case_in_box(self, pos):
        case = 0b111111111
        pos_i = pos[0] / 3 * 3
        pos_j = pos[1] / 3 * 3
        for i in range(0, 3):
            for j in range(0, 3):
                cell = self.__sudoku[pos_i + i][pos_j + j]
                if cell < 0:
                    case = case & ~(1 << (-int(cell) - 1))
        return case

    def __get_cases(self):
        lst = []
        for i in range(0, 9):
            for j in range(0, 9):
                if self.__sudoku[i][j] != 0:
                    self.__sudoku[i][j] = -int(self.__sudoku[i][j])
        for i in range(0, 9):
            for j in range(0, 9):
                tmp = self.__sudoku[i][j]
                pos = (i, j)
                if tmp == 0:
                    n_case = (self.__get_case_in_box(pos)
                              & self.__get_case_for_row(pos)
                              & self.__get_case_in_box(pos))
                    self.__sudoku[i][j] = n_case
                    lst.append((i, j, n_case))
        return sorted(lst, key=lambda c: self.__count_bit_1(c[2]))

    def __pre_init(self):
        self.__case_list = self.__get_cases()

    def __is_num_legal(self, i, j, num):
        pass

    def __update_related_box(self, i, j, num, sudoku):
        pass

    def __DFS(self, cases, sudoku):
        num_used = 0b111111111
        if len(cases) == 0:
            return False
        case = cases[0]
        pos_i = case[0]
        pos_j = case[1]
        found = False
        while True:
            num = self.__get_last_bit_1(case[2] & sudoku[pos_i][pos_j])
            if (num == 0):
                break
            if self.__is_num_legal(num) == False:
                case[2] = case[2] & (num_used & ~( 1 << (num - 1)))
                continue
            if self.__DFS(cases[1:], self.__update_related_box(pos_i, pos_j, num, sudoku)) == False:
                case[2] = case[2] & (num_used & ~( 1 << (num - 1)))
                continue
            self.__steps.append('Put %d at (%d, %d)' % (num, pos_i + 1, pos_j + 1))
            return True
        return found

    def decode(self):
        self.__pre_init()

    def dump(self):
        print self.__sudoku


def main(argv):
    sudoku = Sudoku()
    sudoku.read(argv[0])
    sudoku.decode()
    sudoku.dump()

if __name__ == "__main__":
    main(sys.argv[1:])
