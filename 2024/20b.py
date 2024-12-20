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

premap = {}

#find the best path to any pre-cheat position and from any post-cheat position
def dotry(cost, st, ny, nx):
    (cy, cx) = st
    if ny < 0 or nx < 0 or ny >= H or nx >= W:
        return
    if map[ny][nx] == "#":
        return
    nst = (ny, nx)
    if nst not in stmin:
        stmin[nst] = 99999999
    if cost < stmin[nst]:
        stmin[nst] = cost
        heapq.heappush(sq, (cost, nst))

print("premap...")
dotry(0, (sy, sx), sy, sx)
while len(sq) > 0:
    (cost, st) = heapq.heappop(sq)
    if st in stseen:
        continue
    premap[st] = cost
    stseen.add(st)
    (y, x) = st
    dotry(cost+1, st, y-1, x)
    dotry(cost+1, st, y+1, x)
    dotry(cost+1, st, y  , x-1)
    dotry(cost+1, st, y  , x+1)


sq = []
stseen = set()
stmin = {}

postmap = {}

print("postmap...")

dotry(0, (ey, ex), ey, ex)
while len(sq) > 0:
    (cost, st) = heapq.heappop(sq)
    if st in stseen:
        continue
    postmap[st] = cost
    stseen.add(st)
    (y, x) = st
    dotry(cost+1, st, y-1, x)
    dotry(cost+1, st, y+1, x)
    dotry(cost+1, st, y  , x-1)
    dotry(cost+1, st, y  , x+1)

print("n^2..")
cheats = {}
CHEATMAN = 20 # or 2, for part 1
for cs in premap:
    for ce in postmap:
        man = abs(cs[0]-ce[0]) + abs(cs[1]-ce[1])
        if man > CHEATMAN:
            continue
        cheat = ce,cs
        tcost = premap[cs] + man + postmap[ce]
        if tcost not in cheats:
            cheats[tcost] = set()
        cheats[tcost].add(cheat)

maxcost = premap[(ey, ex)]

wouldsave = 0
ccosts = list(cheats.keys())
ccosts.sort()
for ccost in ccosts:
    print(f"{maxcost - ccost} saved by {len(cheats[ccost])}")
    if maxcost- ccost >= 100:
        wouldsave += len(cheats[ccost])
print(wouldsave) 
