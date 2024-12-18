#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools
from z3 import *
import z3

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 15)

map,moves = d.split('\n\n')

map = [[c for c in s] for s in map.split('\n')]
W = len(map[0])
H = len(map)

boxes = set()
walls = set()

for y in range(H):
    for x in range(W):
        if map[y][x] == "@":
            ry,rx = y,x
        elif map[y][x] == "O":
            boxes.add((y,x))
        elif map[y][x] == "#":
            walls.add((y,x))
        elif map[y][x] == ".":
            pass
        else:
            print(map[y][x])
            ass()

DIRS = { "<": (0, -1), ">": (0, 1), "^": (-1, 0), "v": (1, 0) }

def canpush(y, x, dy, dx):
    if (y, x) in walls:
        return False
    if (y, x) in boxes:
        return canpush(y + dy, x + dx, dy, dx)
    return True

def dopush(y, x, dy, dx):
    assert (y, x) in boxes
    assert((y + dy, x + dx) not in walls)
    if (y+dy, x+dx) in boxes:
        dopush(y+dy, x+dx, dy, dx)
    boxes.remove((y, x))
    boxes.add((y+dy, x+dx))

for m in moves:
    if m == '\n':
        continue
    dy,dx = DIRS[m]
    nry,nrx = ry + dy, rx + dx
    if (nry, nrx) in walls:
        continue
    if (nry, nrx) in boxes:
        if not canpush(nry, nrx, dy, dx):
            continue
        dopush(nry, nrx, dy, dx)
    ry,rx = nry,nrx

gps = 0
for y,x in boxes:
    gps += y * 100 + x
print(gps)