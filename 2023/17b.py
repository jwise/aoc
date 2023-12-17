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

d = get_data(year = 2023, day = 17)
#d = open('16.x', 'r').read()
map = [ [ int(c) for c in s] for s in d.split('\n') ]

W = len(map[0])
H = len(map)

q = []
vseen = {}
vmin = {}
# dijkstra time
# (loss, (y, x, dy, dx, steps))
heapq.heappush(q, (map[1][0], (1, 0, 1, 0, 1)))
heapq.heappush(q, (map[0][1], (0, 1, 0, 1, 1)))
vmin[(1, 0, 1, 0, 1)] = map[1][0]
vmin[(0, 1, 0, 1, 1)] = map[0][1]


TURNL = {
    (0, 1): (-1, 0),
    (-1, 0): (0, -1),
    (0, -1): (1, 0),
    (1, 0): (0, 1),
}

TURNR = {
    (0, 1): (1, 0),
    (-1, 0): (0, 1),
    (0, -1): (-1, 0),
    (1, 0): (0, -1),
}

def visit(cstate, nstate):
    y, x, dy, dx, steps = nstate
    if y >= H or x >= W or y < 0 or x < 0:
        return
    nloss = vmin[cstate] + map[y][x]
    if nstate not in vmin:
        vmin[nstate] = 99999999
    if nloss < vmin[nstate]:
        vmin[nstate] = nloss
        heapq.heappush(q, (nloss, nstate))
        # vprev...

iters = 0
while len(q):
    (loss, state) = heapq.heappop(q)
    if state in vseen:
        continue
    iters += 1
    if iters % 1000 == 0:
        print(iters, len(q), state)
    vseen[state] = True
    (y, x, dy, dx, steps) = state
    if (y, x) == (H-1, W-1) and steps >= 4:
        print(loss) # and we are done
        done()
    if steps < 10:
        visit(state, (y + dy, x + dx, dy, dx, steps + 1))
    if steps >= 4:
        ndy, ndx = TURNL[(dy, dx)]
        visit(state, (y + ndy, x + ndx, ndy, ndx, 1))
        ndy, ndx = TURNR[(dy, dx)]
        visit(state, (y + ndy, x + ndx, ndy, ndx, 1))
    
