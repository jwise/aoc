#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 10)

map = [[int(c) for c in s] for s in d.split('\n')]

W = len(map[0])
H = len(map)

def thscore(y, x, curh = 0):
    if y < 0 or x < 0 or y >= W or x >= H:
        return 0
    if map[y][x] != curh:
        return 0
    if curh == 9:
        return 1
    return thscore(y-1, x, curh+1) + thscore(y+1, x, curh+1) + thscore(y, x-1, curh+1) + thscore(y, x+1, curh+1)

tot = 0
for yy in range(H):
    for xx in range(W):
        tot += thscore(yy, xx)

print(tot)
