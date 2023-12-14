#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 14)
#d = open('14.x', 'r').read()

rows = [[c for c in s] for s in d.split('\n')]

def spin():
    # north
    movedone = True
    while movedone:
        movedone = False
        for y in range(1,len(rows)):
            for x in range(len(rows[0])):
                if rows[y][x] == 'O' and rows[y-1][x] == '.':
                    rows[y][x] = '.'
                    rows[y-1][x] = 'O'
                    movedone = True

    # west
    movedone = True
    while movedone:
        movedone = False
        for x in range(1,len(rows[0])):
            for y in range(len(rows)):
                if rows[y][x] == 'O' and rows[y][x-1] == '.':
                    rows[y][x] = '.'
                    rows[y][x-1] = 'O'
                    movedone = True

    # south
    movedone = True
    while movedone:
        movedone = False
        for y in range(len(rows)-2, -1, -1):
            for x in range(len(rows[0])):
                if rows[y][x] == 'O' and rows[y+1][x] == '.':
                    rows[y][x] = '.'
                    rows[y+1][x] = 'O'
                    movedone = True

    # west
    movedone = True
    while movedone:
        movedone = False
        for x in range(len(rows[0])-2, -1, -1):
            for y in range(len(rows)):
                if rows[y][x] == 'O' and rows[y][x+1] == '.':
                    rows[y][x] = '.'
                    rows[y][x+1] = 'O'
                    movedone = True

def doload():
    score = 0
    for y in range(len(rows)):
        load = len(rows) - y
        for x in range(len(rows[0])):
            if rows[y][x] == 'O':
                score += load
    return score

for n in range(1000):
    spin()
    print(n+1, doload())
