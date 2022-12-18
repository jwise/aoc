#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

# x,y
rocks = [ \
    [(2,0), (3,0), (4,0), (5,0)], \
    [(2,-1), (3,-2), (3,-1), (3,0), (4,-1)], \
    [(2,0), (3,0), (4,0), (4,-1), (4,-2)], \
    [(2,0), (2,-1), (2,-2), (2,-3)], \
    [(2,0), (3,0), (2,-1), (3,-1)], \
]


if True:
    d = get_data(year = 2022, day = 17)
else:
    d = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>X"

def addrock(rock,x,y):
    return [(x0+x,y0+y) for (x0,y0) in rock]

map = {}
maxh = 0

nextj = itertools.cycle(list(d))
nextr = itertools.cycle(rocks)
nrocks = 0
crock = None

def dbg(why, map, crock):
    return
    print(why)
    global maxh
    s = ""
    for y in range(maxh-5,1):
        for x in range(0,7):
            if (x,y) in map:
                s += "#"
            elif (x,y) in crock:
                s += "@"
            else:
                s += "."
        s += "\n"  
    s += "\n"
    print(s)

while nrocks < 2022:
    if crock is None:
        crock = next(nextr)
        crock = addrock(crock, 0, maxh-3)
        dbg("NEW", map, crock)
    
    push = next(nextj)
    if push == "X":
        print("REPEAT")
        push = next(nextj)
    #print(push)
    assert(push == ">" or push == "<")
    maybedir = addrock(crock, 1 if push == ">" else -1, 0)
    bad = False
    for c in maybedir:
        x,y = c
        if x < 0 or x > 6:
            bad = True
            break
        if c in map:
            bad = True
            break
    if not bad:
        crock = maybedir
    dbg("PUSH "+ push, map, crock)
    
    for c in crock:
        assert(c not in map)

    maybedown = addrock(crock, 0, 1)
    bad = False
    for c in maybedown:
        x,y = c
        assert(x >= 0 and x <= 6)
        if y > 0:
            bad = True
            break
        if c in map:
            bad = True
            break
    if bad:
        for c in crock:
            x,y = c
            if (y - 1) < maxh:
                maxh = y - 1
            assert(c not in map)
            map[c] = True
        crock = None
        nrocks += 1
        print(nrocks, -maxh)
        #dbg("DONE", map, [])
    else:
        crock = maybedown
        dbg("DOWN", map, crock)

print(-maxh)
