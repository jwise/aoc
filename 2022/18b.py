#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools

if True:
    d = get_data(year = 2022, day = 18)
else:
    d = """2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5"""

dirs = [(-1,0,0),(1,0,0),(0,-1,0),(0,1,0),(0,0,-1),(0,0,1)]
map = {}
def addtupl(a,b):
    return (a[0]+b[0],a[1]+b[1],a[2]+b[2])

minc = 0
maxc = 0

for l in d.split('\n'):
    x,y,z = [int(c) for c in l.split(',')]
    minc = min(x,y,z,minc)
    maxc = max(x,y,z,maxc)
    map[(x,y,z)] = True
minc -= 1
maxc += 1

# flood fill the outside and mark every cube that we touch
touched = {}
air = {}
q = []
def flood(c):
    global q
    x,y,z = c
    if x > maxc or y > maxc or z > maxc or x < minc or y < minc or z < minc:
        return
    if (x,y,z) in air:
        return
    if (x,y,z) in map:
        touched[(x,y,z)] = True
        return
    air[(x,y,z)] = True
    for d in dirs:
        q.append(addtupl(c,d))
q.append((0,0,0))
while len(q):
    flood(q.pop())

sides = 0
for rock in touched:
    for dir in dirs:
        if addtupl(rock,dir) in air:
            sides += 1

print(sides)