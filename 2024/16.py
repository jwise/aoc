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

d = get_data(year = 2024, day = 16)

map = [[c for c in r] for r in d.split('\n')]
H = len(map)
W = len(map[0])

for y in range(H):
    for x in range(W):
        if map[y][x] == 'S':
            sy,sx = y,x
            map[y][x] = '.'
        if map[y][x] == 'E':
            ey,ex = y,x
            map[y][x] = '.'

TURNL = { (-1, 0): (0, 1), (0, 1): (1, 0), (1, 0): (0, -1), (0, -1): (-1, 0) }
TURNR = { (-1, 0): (0, -1), (0, -1): (1, 0), (1, 0): (0, 1), (0, 1): (-1, 0) }

def search(y,x, dir):
    pass

sq = []
sts = {}

def dotry(y, x, dir, cost):
    if (y, x, dir) in sts:
        return
    sts[(y, x, dir)] = True
    heapq.heappush(sq, (cost, y, x, dir))

dotry(sy, sx, (0, 1), 0)

while len(sq) > 0:
    (cost, y, x, dir) = heapq.heappop(sq)
    print(y, x, dir, cost)
    dy, dx = dir
    if (y,x) == (ey, ex):
        print(cost)
        break
    if map[y + dy][x + dx] == '.':
        dotry(y + dy, x + dx, dir, cost + 1)
    dotry(y, x, TURNL[dir], cost + 1000)
    dotry(y, x, TURNR[dir], cost + 1000)
