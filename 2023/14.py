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
#d = open('13.x', 'r').read()

rows = [[c for c in s] for s in d.split('\n')]

movedone = True
while movedone:
    movedone = False
    for y in range(1,len(rows)):
        for x in range(len(rows[0])):
            if rows[y][x] == 'O' and rows[y-1][x] == '.':
                rows[y][x] = '.'
                rows[y-1][x] = 'O'
                movedone = True

score = 0
for y in range(len(rows)):
    load = len(rows) - y
    for x in range(len(rows[0])):
        if rows[y][x] == 'O':
            score += load

print(score)