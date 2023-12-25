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

q = []
vseen = {}
vmin = {}
# dijkstra time
# (loss, (y, x, stepped))
heapq.heappush(q, (0, (1, 0, frozenset((1, 0)))))
vmin[(1, 0, frozenset((1, 0)))] = 0

def visit(cstate, dy, dx):
    y,x,stepped = cstate
    c = map[y][x]
    if c == '<' and (dy != 0 or dx != -1):
        return
    if c == '>' and (dy != 0 or dx != 1):
        return
    if c == '^' and (dy != -1 or dx != 0):
        return
    if c == 'v' and (dy != 1 or dx != 0):
        return
    
    y += dy
    x += dx
    if (y,x) in stepped:
        return
    if map[y][x] == '#':
        return
    stepped = stepped.union([(y, x)])
    nstate = (y,x,stepped)
    nloss = vmin[cstate] - 1
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
    if iters % 1000 == 0:
        print(iters, len(q), state)
    vseen[state] = True
    (y, x, stepped) = state
    if (y, x) == (H-1, W-2):
        print(loss) # and we are done
        minloss = min(loss, minloss)
        for y in range(H):
            s = ""
            for x in range(W):
                if (y,x) in stepped:
                    s += "O"
                else:
                    s += " "
                s += map[y][x]
            print(s)
    else:
        visit(state, -1, 0)
        visit(state, 1, 0)
        visit(state, 0, -1)
        visit(state, 0, 1)
    
print(minloss)