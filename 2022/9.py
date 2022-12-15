#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

h = [0,0]
t = [0,0]

tvis = {}

d = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"""

d = get_data(year = 2022, day = 9)

tvis[tuple(t)] = True
for l in d.split('\n'):
    dir,n = l.split(' ')
    n = int(n)
    print(l)
    for _ in range(n):
        if dir == 'U':
            h[1] += 1
        elif dir == 'D':
            h[1] -= 1
        elif dir == 'L':
            h[0] -= 1
        elif dir == 'R':
            h[0] += 1
        
        dy = h[1] - t[1]
        dx = h[0] - t[0]
        if (abs(dx) == 0 or abs(dx) == 1) and (abs(dy) == 0 or abs(dy) == 1):
            pass
        elif abs(dx) == 2 and dy == 0:
            t[0] += 1 if dx > 0 else -1
        elif abs(dy) == 2 and dx == 0:
            t[1] += 1 if dy > 0 else -1
        else:
            t[0] += 1 if dx > 0 else -1
            t[1] += 1 if dy > 0 else -1
        
        tvis[tuple(t)] = True
        print(h,t)

print(len(tvis))
            
        
