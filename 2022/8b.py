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

maxss = 0
for ty in range(0,MAXY):
    for tx in range(0,MAXX):
        ss = 1
        sspts = []
        
        # look left
        maxh = map[(ty,tx)]
        y = ty
        x = tx - 1
        n = 0
        while x >= 0:
            n += 1
            if map[(y,x)] >= maxh:
                break
            x -= 1
        ss *= n
        sspts.append(n)
        
        # lookright
        y = ty
        x = tx + 1
        n = 0
        while x < MAXX:
            n += 1
            if map[(y,x)] >= maxh:
                break
            x += 1
        ss *= n
        sspts.append(n)

        # look down
        y = ty + 1
        x = tx 
        n = 0
        while y < MAXY:
            n += 1
            if map[(y,x)] >= maxh:
                break
            y += 1
        ss *= n
        sspts.append(n)
        
        # look up
        y = ty - 1
        x = tx 
        n = 0
        while y >= 0:
            n += 1
            if map[(y,x)] >= maxh:
                break
            y -= 1
        ss *= n
        sspts.append(n)
        
        if ss > maxss:
            maxss = ss
#            print(tx,ty,ss,sspts)

print(maxss)
