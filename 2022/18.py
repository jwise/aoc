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

for l in d.split('\n'):
    x,y,z = [int(c) for c in l.split(',')]
    map[(x,y,z)] = True

sides = 0
for rock in map:
    for dir in dirs:
        if addtupl(rock,dir) not in map:
            sides += 1

print(sides)