#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools, math
from dataclasses import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 22)
    FACESZ = 50
    FACEMAP = {
        1: ((0, 1), [(2, 2), (3, 3), (4, 2), (6, 2)]),
        2: ((0, 2), [(5, 0), (3, 0), (1, 0), (6, 1)]),
        3: ((1, 1), [(2, 1), (5, 3), (4, 3), (1, 1)]),
        4: ((2, 0), [(5, 2), (6, 3), (1, 2), (3, 2)]),
        5: ((2, 1), [(2, 0), (6, 0), (4, 0), (3, 1)]),
        6: ((3, 0), [(5, 1), (2, 3), (1, 3), (4, 1)])
    }
else:
    d = """        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5"""
    FACESZ = 4
    FACEMAP = {
        # ((y,x), [(0face, 0edge), (1face, 1edge), (2face, 2edge), (3face, 3edge)])
        1: ((0, 2), [(6, 0), (4, 3), (3, 3), (2, 3)]),
        2: ((1, 0), [(3, 2), (5, 1), (6, 1), (1, 3)]),
        3: ((1, 1), [(4, 2), (5, 2), (2, 0), (1, 2)]),
        4: ((1, 2), [(6, 3), (5, 3), (3, 0), (1, 1)]),
        5: ((2, 2), [(6, 2), (2, 1), (3, 1), (4, 1)]),
        6: ((2, 3), [(1, 0), (2, 2), (5, 0), (4, 0)])
    }

map = {}

mstr,cmds = d.split('\n\n')

maxx = 0
y=1
for l in mstr.split('\n'):
    x = 1
    for c in l:
        if c != ' ':
            if c == '.':
                map[(y,x)] = True
        x += 1
        maxx = max(maxx, x)
    y += 1

def FACEX(face):
    return FACEMAP[face][0][1] * FACESZ + 1
def FACEY(face):
    return FACEMAP[face][0][0] * FACESZ + 1

maxy = y
def prst(cy,cx,ico):
    for y in range(1,maxy):
        s = ""
        for x in range(1,maxx):
            isinface = False
            for f in FACEMAP:
                if x >= FACEX(f) and x < FACEX(f) + FACESZ and y >= FACEY(f) and y < FACEY(f) + FACESZ:
                    isinface = True
            if not isinface:
                s += " "
                continue
            if (cy,cx) == (y,x):
                s += ico
                continue
            s += "." if (y,x) in map else "#"
        print(s)
    print("")

prst(-1,-1,"")

def idxfromedgepos(y, x, edgeno): # y, x are relative to face, 0 idxed
    print("IDXFROMEDGEPOS", y, x, edgeno)
    if edgeno == 0:
        assert(x == FACESZ - 1)
        return y
    elif edgeno == 1:
        assert(y == FACESZ - 1)
        return FACESZ-1 - x
    elif edgeno == 2:
        assert(x == 0)
        return FACESZ - 1 - y
    elif edgeno == 3:
        assert(y == 0)
        return x
    fuck()

def flipidx(idx):
    return FACESZ - 1 - idx

def edgeposfromidx(edgeno, idx):
    if edgeno == 0:
        return (idx, FACESZ - 1,)
    elif edgeno == 1:
        return (FACESZ - 1, FACESZ - 1 - idx,)
    elif edgeno == 2:
        return (FACESZ - 1 - idx, 0,)
    elif edgeno == 3:
        return (0, idx,)


dirs = [ (0, 1), (1, 0), (0, -1), (-1, 0) ]
opdir = [ 2, 3, 0, 1 ]
dirnam = ">v<^"
cdir = 0
cface = 1
cy = FACEY(cface)
cx = FACEX(cface)
for cmd in re.findall(r'\d+|L|R', cmds):
    if cmd == "L":
        cdir = (cdir + 4 - 1) % 4
        continue
    if cmd == "R":
        cdir = (cdir + 1) % 4
        continue
    for _ in range(int(cmd)):
        print(f"consider move {cy} {cx} {dirnam[cdir]} {cface}")
        ncy = cy + dirs[cdir][0]
        ncx = cx + dirs[cdir][1]
        nface = cface
        ndir = cdir
        cfx = FACEX(cface)
        cfy = FACEY(cface)
        if ncy >= cfy + FACESZ or \
           ncy < cfy or \
           ncx >= cfx + FACESZ or \
           ncx < cfx:
            nface,nedge = FACEMAP[cface][1][cdir]
            idx = idxfromedgepos(cy - cfy, cx - cfx, cdir)
            idx = flipidx(idx)
            nrcy, nrcx = edgeposfromidx(nedge, idx)
            ncy = nrcy + FACEY(nface)
            ncx = nrcx + FACEX(nface)
            ndir = opdir[nedge]
        print(cy,cx,ncy,ncx,dirnam[cdir])
        if (ncy,ncx) in map:
            #prst(cy,cx, dirnam[cdir])
            #print(cy, cx, dirnam[cdir])
            cy,cx,cface,cdir = ncy,ncx,nface,ndir
        else:
            break

print(cy,cx,cdir, cy*1000 + cx*4 + cdir)