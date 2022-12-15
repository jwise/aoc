#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

tvis = {}


NK = 10

rope = [(0,0)] * NK

d = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"""

d = """R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"""
d = get_data(year = 2022, day = 9)

tvis[rope[-1]] = True
for l in d.split('\n'):
    dir,n = l.split(' ')
    n = int(n)
    print(l)
    for _ in range(n):
        if dir == 'U':
            rope[0] = (rope[0][0], rope[0][1] + 1)
        elif dir == 'D':
            rope[0] = (rope[0][0], rope[0][1] - 1)
        elif dir == 'L':
            rope[0] = (rope[0][0] - 1, rope[0][1])
        elif dir == 'R':
            rope[0] = (rope[0][0] + 1, rope[0][1])
        
        for kt in range(NK - 1):
            dy = rope[kt][1] - rope[kt+1][1]
            dx = rope[kt][0] - rope[kt+1][0]
            
            nx = rope[kt+1][0]
            ny = rope[kt+1][1]
            if (abs(dx) == 0 or abs(dx) == 1) and (abs(dy) == 0 or abs(dy) == 1):
                pass
            elif abs(dx) == 2 and dy == 0:
                nx += 1 if dx > 0 else -1
            elif abs(dy) == 2 and dx == 0:
                ny += 1 if dy > 0 else -1
            else:
                nx += 1 if dx > 0 else -1
                ny += 1 if dy > 0 else -1
            rope[kt+1] = (nx,ny)
        
        print(rope)
        
        tvis[rope[-1]] = True

print(len(tvis))
            
        
