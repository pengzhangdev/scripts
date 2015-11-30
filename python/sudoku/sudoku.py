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
import copy

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
        i = ~num + 1
        return (int(math.log(num & i)/(math.log(2))) + 1)

    def __get_case_for_row(self, pos):
        case = 0b111111111
        i = pos[0]
        for j in range(0, 9):
            cell = self.__sudoku[i][j]
            if cell < 0:
                case = case & ~(1 << (-int(cell) - 1))
        #print '%d:%d ==> %s' % (pos[0], pos[1], bin(case))
        return case

    def __get_case_for_column(self, pos):
        case = 0b111111111
        j = pos[1]
        for i in range(0, 9):
            cell = self.__sudoku[i][j]
            if cell < 0:
                case = case & ~(1 << (-int(cell) - 1))
        #print '%d:%d ==> %s' % (pos[0], pos[1], bin(case))
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
        #print '%d:%d ==> %s' % (pos[0], pos[1], bin(case))
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
                    n_case = (self.__get_case_for_column(pos)
                              & self.__get_case_for_row(pos)
                              & self.__get_case_in_box(pos))
                    self.__sudoku[i][j] = n_case
                    lst.append((i, j, n_case))
        return sorted(lst, key=lambda c: self.__count_bit_1(c[2]))

    def __pre_init(self):
        self.__case_list = self.__get_cases()

    def __is_num_legal(self, i, j, num, sudoku):
        item = ~(1 << (num - 1))
        pos_i = i
        for pos_j in range(0, 9):
            cell = sudoku[pos_i][pos_j]
            if pos_i == i and pos_j == j:
                continue
            if cell < 0:
                continue
            if item & cell == 0 :
                return False
        pos_j = j
        for pos_i in range(0, 9):
            cell = sudoku[pos_i][pos_j]
            if pos_i == i and pos_j == j:
                continue
            if cell < 0:
                continue
            if item & cell == 0:
                return False
        pos_i = i / 3 * 3
        pos_j = j / 3 * 3
        for pi in range(0, 3):
            for pj in range(0, 3):
                if pos_i + pi == i and pos_j + pj == j:
                    continue
                cell = sudoku[pos_i + pi][pos_j + pj]
                if cell < 0:
                    continue
                if item & cell == 0:
                    return False

        return True

    def __update_related_box(self, i, j, num, sudoku):
        sudoku[i][j] = -num
        item = ~(1 << (num - 1))
        pos_i = i
        for pos_j in range(0, 9):
            cell = sudoku[pos_i][pos_j]
            if cell < 0:
                continue
            sudoku[pos_i][pos_j] = cell & item
        pos_j = j
        for pos_i in range(0, 9):
            cell = sudoku[pos_i][pos_j]
            if cell < 0:
                continue
            sudoku[pos_i][pos_j] = cell & item
        pos_i = i / 3 * 3
        pos_j = j / 3 * 3
        for pi in range(0, 3):
            for pj in range(0, 3):
                cell = sudoku[pos_i + pi][pos_j + pj]
                if cell < 0:
                    continue
                sudoku[pos_i + pi][pos_j + pj] = cell & item

        return sudoku

    def __dump_stash(self, sudoku):
        for si in range(0, 9):
            print sudoku[si]

    def __DFS(self, cases, sudoku):
        num_used = 0b111111111
        if len(cases) == 0:
            return True
        case = cases[0]
        pos_i = case[0]
        pos_j = case[1]
        cell_case = case[2]
        # print '(%d, %d) ==> %s' % (pos_i, pos_j, cell_case)
        # for si in range(0, 9):
        #     print sudoku[si]
        found = False
        while True:
            num = self.__get_last_bit_1(cell_case & sudoku[pos_i][pos_j])
            if (num == 0):
                #print 'No more case (%d, %d) = %s' % (pos_i, pos_j, bin(case[2]))
                #self.__dump_stash(sudoku)
                break
            if self.__is_num_legal(pos_i, pos_j, num, sudoku) == False:
                #print 'Num test Failed (%d, %d) = %s' %(pos_i, pos_j, num)
                #self.__dump_stash(sudoku)
                cell_case = cell_case & (num_used & ~( 1 << (num - 1)))
                continue
            if self.__DFS(cases[1:]
                          , self.__update_related_box(pos_i, pos_j, num, copy.deepcopy(sudoku))) == False:
                #print 'DFS Failed (%d, %d) = %s' %(pos_i, pos_j, num)
                #self.__dump_stash(sudoku)
                cell_case = cell_case & (num_used & ~( 1 << (num - 1)))
                continue
            self.__steps.append((pos_i, pos_j, num))
            return True
        return found

    def decode(self):
        self.__pre_init()
        self.dump()
        if self.__DFS(self.__case_list, copy.deepcopy(self.__sudoku)) == False:
            print 'No answer for this sudoku'
            return

        print 'The steps for solve this sudoku:'
        self.__steps.reverse()
        for i in range(0, len(self.__steps)):
            step = self.__steps[i]
            print 'Put %d at (%d, %d)' % (step[2], step[0] + 1, step[1] + 1)
            self.__sudoku[step[0]][step[1]] = -step[2]
        for i in range(0, 9):
            for j in range(0, 9):
                print -self.__sudoku[i][j] ,
            print 

    def dump(self):
        print self.__sudoku
        print self.__case_list


def main(argv):
    sudoku = Sudoku()
    sudoku.read(argv[0])
    sudoku.decode()
    #sudoku.dump()

if __name__ == "__main__":
    main(sys.argv[1:])
