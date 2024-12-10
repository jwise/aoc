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

def thtargs(y, x, curh, targs):
    if y < 0 or x < 0 or y >= W or x >= H:
        return
    if map[y][x] != curh:
        return
    if curh == 9:
        targs.add((y, x))
        return
    thtargs(y-1, x, curh+1, targs)
    thtargs(y+1, x, curh+1, targs)
    thtargs(y  , x-1, curh+1, targs)
    thtargs(y  , x+1, curh+1, targs)

tot = 0
for yy in range(H):
    for xx in range(W):
        targs = set()
        thtargs(yy, xx, 0, targs)
        if len(targs) > 0:
            print(yy, xx, len(targs))
            tot += len(targs)

print(tot)
