#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

d = get_data(year = 2023, day = 16)
#d = open('16.x', 'r').read()
map = [ [ { "c": c } for c in s] for s in d.split('\n') ]

W = len(map[0])
H = len(map)

# y, x, dy, dx
def tryone(y, x, dy, dx):
    active = [ ( (y, x), (dy, dx) ) ]
    map = [ [ { "c": c } for c in s] for s in d.split('\n') ]

    while len(active) > 0:
        ((y, x), (dy, dx)) = active.pop()
    
        map[y][x][(dy, dx)] = True
        map[y][x]['energized'] = True
        if map[y][x]['c'] == '.':
            ds = [(dy, dx)]
        elif map[y][x]['c'] == '/':
            ds = [(-dx, -dy)]
        elif map[y][x]['c'] == '\\':
            ds = [(dx, dy)]
        elif map[y][x]['c'] == '|':
            if dx == 0:
                ds = [(dy, dx)]
            else:
                ds = [(1, 0), (-1, 0)]
        elif map[y][x]['c'] == '-':
            if dy == 0:	
                ds = [(dy, dx)]
            else:
                ds = [(0, 1), (0, -1)]
        else:
            ass()
    
        for (dy, dx) in ds:
            ny = y + dy
            nx = x + dx
            if ny < 0 or ny >= H or nx < 0 or nx >= W:
                continue
            nbox = map[ny][nx]
            if (dy, dx) in nbox:
                continue
            ntup = ((ny, nx), (dy, dx))
            if ntup not in active:
                active.append(ntup)

    energized = 0
    for row in map:
        for col in row:
            if 'energized' in col:
                energized += 1
    return energized

best = 0
configs = []
for y in range(0, H):
    configs.append((y, 0, 0, 1))
    configs.append((y, W-1, 0, -1))
for x in range(0, W):
    configs.append((0, x, 1, 0))
    configs.append((H-1, x, -1, 0))

for config in configs:
    val = tryone(*config)
    if val > best:
        print(config, val)
        best = val

print(best)