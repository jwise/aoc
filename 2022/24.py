#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools, math
from dataclasses import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 24)
else:
    d = """#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#"""

map = {}

y=0
for l in d.split('\n'):
    x = 0
    for c in l:
        if c != '.':
            map[(y,x)] = [c]
        x += 1
    y += 1
maxy = y-1
maxx = x-1

maps = [map]
def stepmap(map):
    nmap = defaultdict(list)
    for y,x in map:
        for elt in map[(y,x)]:
            if elt == '#':
                nmap[(y,x)].append('#')
            elif elt == '>':
                nmap[(y,x+1 if x != maxx-1 else 1)].append('>')
            elif elt == 'v':
                nmap[(y+1 if y != maxy-1 else 1,x)].append('v')
            elif elt == '<':
                nmap[(y,x-1 if x != 1 else maxx - 1)].append('<')
            elif elt == '^':
                nmap[(y-1 if y != 1 else maxy - 1,x)].append('^')
    return nmap

def rununtil(step, fry, frx, toy, tox):
    q = deque()
    q.append((step, fry, frx))
    mvis = {}
    while len(q):
        turn,y,x = q.popleft()
        while len(maps) <= turn:
            maps.append(stepmap(maps[turn-1]))
            #print(turn, len(q))
        if (y,x) in maps[turn]:
            continue
        if (y,x) == (toy, tox):
            print("GOT IT", turn)
            break
        def visit(t,y,x):
            if y < 0 or x < 0 or y > maxy:
                return
            if (t,y,x) not in mvis:
                q.append((t,y,x))
                mvis[(t,y,x)] = True
        visit(turn+1, y+1, x)
        visit(turn+1, y-1, x)
        visit(turn+1, y, x+1)
        visit(turn+1, y, x-1)
        visit(turn+1, y, x)
    return turn

s0 = rununtil(0, 0, 1, maxy, maxx - 1)
s1 = rununtil(s0, maxy, maxx - 1, 0, 1)
s2 = rununtil(s1, 0, 1, maxy, maxx - 1)
