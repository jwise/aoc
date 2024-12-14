#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools
from z3 import *
import z3

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

for tick in range(100):
    for ri,(px,py,dx,dy) in enumerate(rs):
        #px,py,dx,dy = rs[ri]
        
        px += dx
        py += dy
        
        px += GW
        py += GH
        
        px %= GW
        py %= GH
        
        rs[ri] = (px, py, dx, dy)

q0, q1, q2, q3 = (0, 0, 0, 0)
for (px,py,dx,dy) in rs:
    if px < (GW-1)/2 and py < (GH-1)/2:
        q0 += 1
    if px < (GW-1)/2 and py > (GH-1)/2:
        q1 += 1
    if px > (GW-1)/2 and py < (GH-1)/2:
        q2 += 1
    if px > (GW-1)/2 and py > (GH-1)/2:
        q3 += 1

print(q0, q1, q2, q3)
print(q0 * q1 * q2 * q3)
        