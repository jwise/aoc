#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools, math
from dataclasses import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 23)
else:
    d = """....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#.."""
    #d = """.....
#..##.
#..#..
#.....
#..##.
#....."""

map = {}

y=0
for l in d.split('\n'):
    x = 0
    for c in l:
        if c=='#':
            map[(y,x)] = True
        x += 1
    y += 1

seq = ['N', 'S', 'W', 'E']
def round(map, seqp):
    nmapprop = {}
    proposals = defaultdict(lambda: 0)
    nmap = {}
    
    didmove = False
    for (y,x) in map:
        propos = (y,x)
        if (y-1,x) not in map and (y-1,x-1) not in map and (y-1,x+1) not in map and (y, x-1) not in map and (y, x+1) not in map and (y+1, x-1) not in map and (y+1, x) not in map and (y+1, x+1) not in map:
            nmapprop[(y,x)] = propos
            proposals[propos] += 1
            continue
        for seqpp in range(0,4):
            seqr = seq[(seqp + seqpp) % 4]
            if seqr == 'N':
                if (y-1,x) not in map and (y-1,x-1) not in map and (y-1,x+1) not in map:
                    propos = (y-1,x)
                    break
            elif seqr == 'S':
                if (y+1,x) not in map and (y+1,x-1) not in map and (y+1,x+1) not in map:
                    propos = (y+1,x)
                    break
            elif seqr == 'W':
                if (y,x-1) not in map and (y+1,x-1) not in map and (y-1,x-1) not in map:
                    propos = (y,x-1)
                    break
            elif seqr == 'E':
                if (y,x+1) not in map and (y+1,x+1) not in map and (y-1,x+1) not in map:
                    propos = (y,x+1)
                    break
        didmove = True
        nmapprop[(y,x)] = propos
        proposals[propos] += 1
    
    for old in nmapprop:
        propos = nmapprop[old]
        if proposals[propos] > 1:
            nmap[old] = True
        else:
            nmap[propos] = True
    
    return nmap, didmove
    
def bounds(map):
    minx, miny = 9999999, 9999999
    maxx, maxy = -9999999, -9999999
    
    for (y,x) in map:
        if x > maxx:
            maxx = x
        if x < minx:
            minx = x
        if y > maxy:
            maxy = y
        if y < miny:
            miny = y
    
    return (minx, miny, maxx, maxy)

def pr(map):
    minx,miny,maxx,maxy = bounds(map)
    for y in range(miny,maxy+1):
        s = ""
        for x in range(minx,maxx+1):
            if (y,x) in map:
                s += "#"
            else:
                s += "."
        print(s)

for r in range(0,10):
    print(f"round {r}")
    pr(map)
    print("")
    map, didmove = round(map, r)

minx, miny, maxx, maxy = bounds(map)
print(bounds(map))
empty = 0
for y in range(miny,maxy+1):
    for x in range(minx,maxx+1):
        if (y,x) not in map:
            empty += 1

print(empty)