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

d = get_data(year = 2024, day = 20)
#d = open('20.x', 'r').read()

map = [[c for c in r] for r in d.split('\n')]
H = len(map)
W = len(map[0])

for y in range(H):
    for x in range(W):
        if map[y][x] == 'S':
            sy,sx = y,x
            map[y][x] = '.'
        if map[y][x] == 'E':
            ey,ex = y,x
            map[y][x] = '.'

sq = []
stseen = set()
stmin = {}

postcheats = {}

#find the best path to any post-cheat position, and the cheat starts that get you there

def dotry(cost, st, ny, nx):
    (cy, cx, csy, csx, cr) = st
    if ny < 0 or nx < 0 or ny >= H or nx >= W:
        return
    ncr = cr
    if map[ny][nx] == "#":
        if cr == 2:
            # begin a cheat
            ncr = 1
            csy = cy
            csx = cx
        else:
            return
    if cr == 1:
        #cey, cex = ny, nx
        ncr = 0
        cs = (csy, csx)
        ce = (ny, nx)
        if ce not in postcheats:
            postcheats[ce] = {}
        if cs not in postcheats[ce]:
            postcheats[ce][cs] = 99999999
        if cost < postcheats[ce][cs]:
            postcheats[ce][cs] = cost
        return

    nst = (ny, nx, csy, csx, ncr)
    if nst not in stmin:
        stmin[nst] = 99999999
    if cost < stmin[nst]:
        stmin[nst] = cost
        heapq.heappush(sq, (cost, nst))

dotry(0, (sy, sx, -1, -1, 2), sy, sx)


iters = 0
while len(sq) > 0:
    iters += 1
    if iters % 100000 == 0:
        print(iters, cost, len(sq))
    (cost, st) = heapq.heappop(sq)
    if st in stseen:
        continue
    stseen.add(st)
    (y, x, csy, csx, cr) = st
    if (y,x) == (ey, ex):
        #cheat = csy, csx, cey, cex
        print(cost, st)
        if cr == 2:
            maxcost = cost
            break
    dotry(cost+1, st, y-1, x)
    dotry(cost+1, st, y+1, x)
    dotry(cost+1, st, y  , x-1)
    dotry(cost+1, st, y  , x+1)


# lol, A* my ass
cheats_seen = set()
cheats = {}

sq = []
stseen = set()
stmin = {}
costmap = {}
dotry(0, (ey, ex, -1, -1, 0), ey, ex)
while len(sq) > 0:
    iters += 1
    if iters % 100000 == 0:
        print(iters, cost, len(sq))
    (cost, st) = heapq.heappop(sq)
    if st in stseen:
        continue
    costmap[st] = cost
    stseen.add(st)
    (y, x, csy, csx, cr) = st
    dotry(cost+1, st, y-1, x)
    dotry(cost+1, st, y+1, x)
    dotry(cost+1, st, y  , x-1)
    dotry(cost+1, st, y  , x+1)
 
for ce in postcheats:
    for cs in postcheats[ce]:
        cey, cex = ce
        cheat = cs, cey, cex
        tcost = costmap[(cey, cex, -1, -1, 0)] + postcheats[ce][cs]
        if cheat not in cheats_seen:
            if tcost not in cheats:
                cheats[tcost] = set()
            cheats[tcost].add(cheat)
            cheats_seen.add(cheat)
        
    print(ce, cost)

wouldsave = 0
ccosts = list(cheats.keys())
ccosts.sort()
for ccost in ccosts:
    print(f"{maxcost - ccost} saved by {len(cheats[ccost])}")
    if maxcost- ccost >= 100:
        wouldsave += len(cheats[ccost])
print(wouldsave) 
