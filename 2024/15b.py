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
#d = open('15.x2').read()

map,moves = d.split('\n\n')

map = [[c for c in s] for s in map.split('\n')]
W = len(map[0])
H = len(map)

# boxes are coord at their left edge
boxes = set()
walls = set()

for y in range(H):
    for x in range(W):
        if map[y][x] == "@":
            ry,rx = y,x*2
        elif map[y][x] == "O":
            boxes.add((y,x*2))
        elif map[y][x] == "#":
            walls.add((y,x*2))
            walls.add((y,x*2+1))
        elif map[y][x] == ".":
            pass
        else:
            print(map[y][x])
            ass()

DIRS = { "<": (0, -1), ">": (0, 1), "^": (-1, 0), "v": (1, 0) }

# true iff (y, x) is a box that can be pushed left
def canpushl(y, x):
    assert (y, x) in boxes
    assert (y, x - 1) not in boxes
    if (y, x - 1) in walls:
        return False
    if (y, x - 2) in boxes:
        return canpushl(y, x - 2)
    return True

def dopushl(y, x):
    assert (y, x) in boxes
    assert (y, x - 1) not in boxes
    assert (y, x - 1) not in walls
    if (y, x - 2) in boxes:
        dopushl(y, x - 2)
    boxes.remove((y, x))
    boxes.add((y, x-1))
    print(f"pushed box L {y} {x} -> {y} {x-1}")

def canpushr(y, x):
    if (y, x) in walls:
        return False
    print(y,x)
    if (y, x) in boxes:
        assert (y, x+1) not in boxes
        return canpushr(y, x + 2)
    return True

def dopushr(y, x):
    assert (y, x) in boxes
    assert ((y, x+1) not in walls)
    assert ((y, x+2) not in walls)
    if (y, x+2) in boxes:
        dopushr(y, x+2)
    assert ((y, x+1) not in boxes)
    boxes.remove((y, x))
    boxes.add((y, x+1))
    print(f"pushed box R {y} {x} -> {y} {x+1}")

# true iff (y, x) is an empty spot or part of a box that can be pushed with velocity dy
def canpushv(y, x, dy):
    if (y, x) in walls:
        return False
    if (y, x-1) in boxes:
        return canpushv(y+dy, x-1, dy) and canpushv(y+dy, x, dy)
    if (y, x) in boxes:
        return canpushv(y+dy, x, dy) and canpushv(y+dy, x+1, dy)
    return True

def dopushv(y, x, dy):
    print(f"V {y} {x}")
    assert (y, x) in boxes
    assert (y, x+1) not in boxes
    assert (y + dy, x) not in walls
    assert (y + dy, x+1) not in walls
    if (y+dy, x-1) in boxes:
        dopushv(y+dy, x-1, dy)
    if (y+dy, x) in boxes:
        dopushv(y+dy, x, dy)
    if (y+dy, x+1) in boxes:
        dopushv(y+dy, x+1, dy)
    boxes.remove((y, x))
    boxes.add((y+dy, x))
    assert (y+dy, x+1) not in boxes
    assert (y+dy, x+1) not in walls
    
    print(f"pushed box V {y} {x} {dy} -> {y+dy} {x}")

for m in moves:
    if m == '\n':
        continue
    dy,dx = DIRS[m]
    nry,nrx = ry + dy, rx + dx
    print(m, nry, nrx, (nry, nrx) in walls, (nry, nrx) in boxes, (nry, nrx-1) in boxes)
    if (nry, nrx) in walls:
        continue
    assert not (m == "<" and (nry, nrx) in boxes)
    if (nry, nrx-1) in boxes and m == "<":
        if not canpushl(nry, nrx-1):
            continue
        dopushl(nry, nrx-1)
    if (nry, nrx) in boxes and m == ">":
        if not canpushr(nry, nrx):
            continue
        dopushr(nry, nrx)
    if (nry, nrx-1) in boxes and dy != 0:
        if not (canpushv(nry, nrx-1, dy) and canpushv(nry, nrx, dy)):
            continue
        dopushv(nry, nrx-1, dy)
    if (nry, nrx) in boxes and dy != 0:
        if not (canpushv(nry, nrx, dy) and canpushv(nry, nrx+1, dy)):
            continue
        dopushv(nry, nrx, dy)

    ry,rx = nry,nrx

gps = 0
for y,x in boxes:
    assert (y, x+1) not in boxes
    assert (y, x) not in walls
    assert (y, x+1) not in walls
    gps += y * 100 + x
print(gps)