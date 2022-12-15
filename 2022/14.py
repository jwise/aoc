#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

map = {}

d="""498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"""
d = get_data(year = 2022, day = 14)

ymax = 0

def line(p1, p2):
    global ymax
    p1y,p1x = p1
    p2y,p2x = p2
    if p1y == p2y:
        for x in range(min(p1x,p2x),max(p1x,p2x)+1):
            map[(p1y,x)] = "#"
    elif p1x == p2x:
        for y in range(min(p1y,p2y),max(p1y,p2y)+1):
            map[(y,p1x)] = "#"
    else:
        assert(False)
    ymax = max(p1y, p2y, ymax)

for l in d.split('\n'):
    print(l)
    plast = None
    for p in l.split(' -> '):
        x,y = [int(i) for i in p.split(',')]
        p = (y,x)
        if plast is not None:
            line(plast, p)
        plast = p

print(map)

grains = 0
while True:
    gx,gy = 500,0
    
    while True:
        if gy > ymax:
            break
        if (gy+1,gx) not in map:
            gy += 1
            continue
        if (gy+1, gx-1) not in map:
            gy += 1
            gx -= 1
            continue
        if (gy+1, gx+1) not in map:
            gy += 1
            gx += 1
            continue
        # we appear to be blocked
        map[(gy,gx)] = 'o'
        break

    print(gy, gx, ymax)
    if gy > ymax:
        break
    grains += 1

print(grains)