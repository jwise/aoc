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

d = get_data(year = 2024, day = 14)

GW = 101
GH = 103

rs = []
for r in d.split('\n'):
    px,py,dx,dy = extract(r)
    rs.append((px, py, dx, dy))

for tick in range(20000):
    g = [[0] * GW for _ in range(GH)]
    for ri,(px,py,dx,dy) in enumerate(rs):
        #px,py,dx,dy = rs[ri]
        
        px += dx
        py += dy
        
        px += GW
        py += GH
        
        px %= GW
        py %= GH
        
        rs[ri] = (px, py, dx, dy)
        
        g[py][px] += 1
    
    # look for a run of 1s at this tick
    for row in g:
        s = "".join([str(n) for n in row])
        #if tick == 7857:
        #    print(s)
        if "111111" in s:
            print(tick, s)
            # bss ol bar: tick + 1, ya doof, because it's *after* this tick
