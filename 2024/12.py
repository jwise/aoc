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

d = get_data(year = 2024, day = 12)

map = [[c for c in s] for s in d.split('\n')]

filled = set()
regions = []
xmap = {}
rn = 0

w = len(map[0])
h = len(map)

def flood(y, x, c, s, rn):
    if y < 0 or y >= h or x < 0 or x >= h:
        return
    if map[y][x] != c:
        return
    if (y, x) in filled:
        return
    s.add((y, x))
    filled.add((y, x))
    xmap[(y, x)] = rn
    flood(y-1, x, c, s, rn)
    flood(y+1, x, c, s, rn)
    flood(y, x-1, c, s, rn)
    flood(y, x+1, c, s, rn)

for y in range(len(map)):
    for x in range(len(map[0])):
        if (y, x) in filled:
            continue
        r = set()
        flood(y, x, map[y][x], r, rn)
        regions.append(r)
        rn += 1

regions_perims = []
tot = 0
tot2 = 0
for r in regions:
    perim = 0
    rp_hi = {} # horiz above point, y-major
    rp_ho = {} # horiz above point, y-major
    rp_vi = {} # vert left point, x-major
    rp_vo = {} # vert left point, x-major
    for y, x in r:
        if (y-1, x) not in r:
            perim += 1
            if y not in rp_hi:
                rp_hi[y] = []
            rp_hi[y].append(x)
        if (y+1, x) not in r:
            perim += 1
            if y+1 not in rp_ho:
                rp_ho[y+1] = []
            rp_ho[y+1].append(x)
        if (y, x-1) not in r:
            perim += 1
            if x not in rp_vi:
                rp_vi[x] = []
            rp_vi[x].append(y)
        if (y, x+1) not in r:
            perim += 1
            if x+1 not in rp_vo:
                rp_vo[x+1] = []
            rp_vo[x+1].append(y)
    tot += perim * len(r)
    
    sides = 0
    for y,xs in rp_hi.items():
        xs.sort()
        lx = -2
        for x in xs:
            if x != lx + 1:
                sides += 1
            lx = x
    for y,xs in rp_ho.items():
        xs.sort()
        lx = -2
        for x in xs:
            if x != lx + 1:
                sides += 1
            lx = x
    for x,ys in rp_vi.items():
        ys.sort()
        ly = -2
        for y in ys:
            if y != ly + 1:
                sides += 1
            ly = y
    for x,ys in rp_vo.items():
        ys.sort()
        ly = -2
        for y in ys:
            if y != ly + 1:
                sides += 1
            ly = y
    tot2 += sides * len(r)
print(tot)
print(tot2)

#tot2 = 0
#for r, (rp_h, rp_v) in zip(regions, regions_perims):
    # segment 
    
        