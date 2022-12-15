#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

d="""30373
25512
65332
33549
35390"""
d = get_data(year = 2022, day = 8)

map = {}
y = 0
for l in d.split('\n'):
    x = 0
    for c in l:
        map[(y,x)] = int(c)
        x += 1
    y += 1

vis = {}
MAXX = x
MAXY = y

for y in range(0,MAXY):
    maxh = -1
    for x in range(0,MAXX):
        # look from the left
        if map[(y,x)] > maxh:
            vis[(y,x)] = True
            maxh = map[(y,x)]

for y in range(0,MAXY):
    maxh = -1
    for x in range(0,MAXX):
        x = MAXX-x-1
        # look from the right
        if map[(y,x)] > maxh:
            vis[(y,x)] = True
            maxh = map[(y,x)]

#from top
for x in range(0,MAXX):
    maxh = -1
    for y in range(0,MAXY):
        if map[(y,x)] > maxh:
            vis[(y,x)] = True
            maxh = map[(y,x)]

#from bottom
for x in range(0,MAXX):
    maxh = -1
    for y in range(0,MAXY):
        y = MAXY-y-1
        if map[(y,x)] > maxh:
            vis[(y,x)] = True
            maxh = map[(y,x)]

print(len(vis))
