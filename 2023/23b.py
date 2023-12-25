#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

d = get_data(year = 2023, day = 23)
#d = open('23.x', 'r').read()
map = [ [ c for c in s] for s in d.split('\n') ]

W = len(map[0])
H = len(map)

# make a graph...
nodes = {}
for y in range(H):
    for x in range(W):
        if map[y][x] == '#':
            continue
        nnbrs = 0
        if y == 0 or map[y-1][x] != '#':
            nnbrs += 1
        if y == H-1 or map[y+1][x] != '#':
            nnbrs += 1
        if map[y][x-1] != '#':
            nnbrs += 1
        if map[y][x+1] != '#':
            nnbrs += 1
        if nnbrs > 2:
            nodes[(y, x)] = []
nodes[(0, 1)] = []
nodes[(H-1, W-2)] = []

nids = {}
nid = 0
for y0,x0 in nodes:
    s = set()
    nids[(y0, x0)] = nid
    nid += 1
    def fnbrs(y, x, steps):
        if y < 0 or y >= H:
            return
        if map[y][x] == '#':
            return
        if (y, x) in s:
            return
        if (y, x) in nodes and (y, x) != (y0, x0):
            nodes[(y0, x0)].append((y, x, steps))
            return
        s.add((y, x))
        fnbrs(y-1, x, steps + 1)
        fnbrs(y+1, x, steps + 1)
        fnbrs(y, x-1, steps + 1)
        fnbrs(y, x+1, steps + 1)
    fnbrs(y0, x0, 0)

for y0,x0 in nodes:
    print(y0, x0, nodes[(y0, x0)])

print(len(nodes))

@functools.lru_cache(maxsize = None)
def maxlen(y, x, visited):
    if (y, x) == (H-1, W-2):
        return 0
    mm = 0
    didstepped = 0
    for ny, nx, nsteps in nodes[(y, x)]:
        if visited & (1 << nids[(ny, nx)]):
            continue
        didstepped += 1
        thismaxlen = maxlen(ny, nx, visited | (1 << nids[(ny, nx)]))
        if thismaxlen is not None:
            thismaxlen += nsteps
            if thismaxlen > mm:
                mm = thismaxlen
    if didstepped == 0:
        return None
    return mm

print(maxlen(0, 1, 1 << nids[(0, 1)]))
ass()

q = []
vseen = {}
vmin = {}
# dijkstra time
# (loss, (y, x, visited))
heapq.heappush(q, (0, (0, 1, frozenset((0, 1)))))
vmin[(0, 1, frozenset((0, 1)))] = 0

def visit(cstate, ny, nx, nsteps):
    y,x,stepped = cstate

    if (ny,nx) in stepped:
        return
    nstate = ny, nx, stepped.union([(ny, nx)])
    nloss = vmin[cstate] - nsteps
    if nstate not in vmin:
        vmin[nstate] = 0
    if nloss < vmin[nstate]:
        vmin[nstate] = nloss
        heapq.heappush(q, (nloss, nstate))
        # vprev...

iters = 0
minloss = 0
while len(q):
    (loss, state) = heapq.heappop(q)
    if state in vseen:
        continue
    iters += 1
    if iters % 10000 == 0:
        print(iters, len(q))
    vseen[state] = True
    (y, x, stepped) = state
    for ny,nx,nsteps in nodes[(y, x)]:
        visit(state, ny, nx, nsteps)
    if (y, x) == (H-1, W-2):
        l = loss - nsteps + 1
        if l < minloss:
            print(l)
            minloss = l
    
print(minloss)