#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools, math
from dataclasses import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 22)
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

map = {}

mstr,cmds = d.split('\n\n')

xmins = [None] # 1-based
xmaxs = [None]
maxlen = max([len(l) for l in d.split('\n')])
ymins = [999999] * (maxlen + 1)
ymaxs = [-1] * (maxlen + 1)
y=1
for l in mstr.split('\n'):
    x = 1
    xmin = 9999999
    xmax = -1
    for c in l:
        if c != ' ':
            xmax = max(x,xmax)
            xmin = min(x,xmin)
            ymins[x] = min(ymins[x], y)
            ymaxs[x] = max(ymaxs[x], y)
            if c == '.':
                map[(y,x)] = True
        x += 1
    xmins.append(xmin)
    xmaxs.append(xmax)
    y += 1

def prst(cy,cx,ico):
    for y in range(1,max(ymaxs[1:])+1):
        s = ""
        for x in range(1, max(xmaxs[1:])+1):
            if x < xmins[y] or x > xmaxs[y] or y < ymins[x] or y > ymaxs[x]:
                s += " "
                continue
            s += "." if (y,x) in map else "#"
        print(s)
    print("")

prst(0,0,0)

dirs = [ (0, 1), (1, 0), (0, -1), (-1, 0) ]
dirnam = ">v<^"
cdir = 0
cy = 1
cx = xmins[1]
for cmd in re.findall(r'\d+|L|R', cmds):
    if cmd == "L":
        cdir = (cdir + 4 - 1) % 4
        continue
    if cmd == "R":
        cdir = (cdir + 1) % 4
        continue
    for _ in range(int(cmd)):
        ncy = cy + dirs[cdir][0]
        ncx = cx + dirs[cdir][1]
        if ncy > ymaxs[cx]:
            ncy = ymins[cx]
        if ncy < ymins[cx]:
            ncy = ymaxs[cx]
        if ncx > xmaxs[cy]:
            ncx = xmins[cy]
        if ncx < xmins[cy]:
            ncx = xmaxs[cy]
        print(cy,cx,ncy,ncx,dirnam[cdir])
        if (ncy,ncx) in map:
            print(cy, cx, dirnam[cdir])
            cy,cx = ncy,ncx
        else:
            break

print(cy,cx,cdir, cy*1000 + cx*4 + cdir)