#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 6)

map = [ [c for c in l] for l in d.split('\n') ]

xmax = len(map[0])
ymax = len(map)

visited = set()

gy,gx = None,None

for y in range(ymax):
    for x in range(xmax):
        if map[y][x] == '^':
            gy, gx = y,x
            map[y][x] = '.'

gdir = (-1, 0)

gturnr = {
  (-1, 0): (0, 1),
  (0, 1): (1, 0),
  (1, 0): (0, -1),
  (0, -1): (-1, 0)
}

gy0, gx0 = gy, gx
while gy >= 0 and gy < ymax and gx >= 0 and gx < xmax:
    if map[gy][gx] == '#':
        gy,gx = gy-gdir[0], gx-gdir[1]
        gdir = gturnr[gdir]
    visited.add((gy, gx))
    gy,gx = gy+gdir[0], gx+gdir[1]

print(len(visited))

nloops = 0
for oy,ox in visited:
    gy,gx = gy0, gx0
    gdir = (-1, 0)
    xvisited = set()
    while gy >= 0 and gy < ymax and gx >= 0 and gx < xmax:
        if map[gy][gx] == '#' or (gy == oy and gx == ox):
            gy,gx = gy-gdir[0], gx-gdir[1]
            gdir = gturnr[gdir]
        if (gy, gx, gdir) in xvisited:
            nloops += 1
            break
        xvisited.add((gy, gx, gdir))
        gy,gx = gy+gdir[0], gx+gdir[1]

print(nloops)
