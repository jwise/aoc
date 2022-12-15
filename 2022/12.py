#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse


d = """Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"""
d = get_data(year = 2022, day = 12)

map = {}
y = 0
start = None
end = None
for l in d.split('\n'):
    x = 0
    for c in l:
        if c == 'S':
            start = (y,x)
            c = 'a'
        elif c == 'E':
            end = (y,x)
            c = 'z'
        map[(y,x)] = ord(c) - ord('a')
        x += 1
    y += 1
maxx = x - 1
maxy = y - 1
print(map,start,end)

mdist = {}
mprev = {}
q = []

def visit(y,x,d,oldh):
    d = d + 1
    if y < 0 or y > maxy:
        return
    if x < 0 or x > maxx:
        return
    if map[(y,x)] > oldh + 1:
        return
    if d < mdist[(y,x)]:
        mdist[(y,x)] = d

for pt in map:
    mdist[pt] = 99999
    q.append(pt)

mdist[start] = 0

while len(q):
    q.sort(key = lambda pt: mdist.get(pt))
    el = q.pop(0)
    y,x = el
    visit(y+1, x  , mdist[el], map[el])
    visit(y-1, x  , mdist[el], map[el])
    visit(y  , x+1, mdist[el], map[el])
    visit(y  , x-1, mdist[el], map[el])

print(mdist[end]) 