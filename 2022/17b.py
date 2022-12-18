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
    d = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

def addrock(rock,x,y):
    return [(x0+x,y0+y) for (x0,y0) in rock]

map = {}
maxh = 0

jmod = 0
rmod = 0
nrocks = 0

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

def sthash():
    global maxh
    s = ""
    for y in range(maxh-5,maxh+500):
        for x in range(0,7):
            if (x,y) in map:
                s += "#"
            else:
                s += "."
    return (jmod, rmod, s)

sts = {}

def runrock():
    global maxh
    global map
    global rmod
    global jmod
    crock = rocks[rmod]
    rmod = (rmod + 1) % 5
    crock = addrock(crock, 0, maxh-3)
    dbg("NEW", map, crock)

    while crock is not None:
        push = d[jmod]
        jmod = (jmod + 1) % len(d)
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
            break
        crock = maybedown

while True:
    runrock()
    nrocks += 1
    print(nrocks, -maxh)
    sth = sthash()
    if sth in sts:
        prevnrocks, prevmaxh = sts[sth]
        print(f"GOT A HIT: now {nrocks}, {maxh} was last seen at {prevnrocks}, {prevmaxh}")
        break
    sts[sth] = (nrocks, maxh)

# How many do we step nrocks forward by?
dnr = nrocks - prevnrocks
dmaxh = maxh - prevmaxh

steps = (1000000000000 - nrocks) // dnr
ofsmaxh = dmaxh * steps
remainder = 1000000000000 - (nrocks + steps * dnr)

print(f"delta nrocks {dnr}, delta maxh {dmaxh}, will take {steps} megasteps for offset {ofsmaxh}, remainder {remainder}")

for _ in range(remainder):
    runrock()

print(-maxh - ofsmaxh)
