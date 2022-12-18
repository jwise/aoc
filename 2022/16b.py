#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, heapq
from itertools import chain

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

TIME=26

if True:
    d = get_data(year = 2022, day = 16)
else:
    d="""Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II"""

valves = {}
nvalves = 0
vn = 0
for l in d.split('\n'):
    print(l)
    v,r,ts = re.match(r"Valve (.*) has flow rate=(.*); tunnel[s]* lead[s]* to valve[s]* (.*)$", l).groups()
    r = int(r)
    ts = ts.split(', ')
    valves[v] = { 'r': r, 'ts': ts, 'bit': 1 << vn }
    if r != 0:
        nvalves += 1
    vn += 1

#print(dfs('AA', [], 0, 0, 0))

#barf()

# a graph node has state { current position, elephant position, valves open, time }
vmax = {}
vprev = {}
vseen = {}

q = []
# vmax has (pressure committed to release)
vmax[('AA', 'AA', 0, 0)] = (0)
heapq.heappush(q, ((0), ('AA', 'AA', 0, 0)))

# delta flow rate 
def visit(cst, nst, dfr = 0):
    cwhere, cel, copen, tnow = cst
    nwhere, nel, nopen = nst
    
    pcrnow = vmax[cst]
    tnow += 1
    if tnow > TIME:
        return
    pcrnow += (TIME - tnow) * dfr
    nst = (nwhere, nel, nopen, tnow)
    if nwhere > nel:
        nwhere, nel = nel, nwhere

    if nst not in vmax:
        vmax[nst] = (-1)
    pcrbest = vmax[nst]
    if pcrnow > pcrbest:
        heapq.heappush(q, ((-pcrnow * 60 + tnow), nst))
        vmax[nst] = pcrnow
        vprev[nst] = cst

iters = 0
while len(q):
    cost,state = heapq.heappop(q)
    if state in vseen:
        continue
    vseen[state] = True
    iters += 1
    if iters % 1000 == 0:
        print(iters, len(q))
    where, elwhere, open, pcr = state
    #DEBUG = [
    #    ('GG', ('BB', 'DD', 'HH', 'JJ')),
    #    ('HH', ('BB', 'DD', 'HH', 'JJ'))
    #]
    #if (where, open) in DEBUG:
    #    print('ITER:', state, vmax[state])
    couldopen = False
    elcouldopen = False
    if (valves[where]['bit'] & open) == 0 and valves[where]['r'] != 0:
        couldopen = True
    if (valves[elwhere]['bit'] & open) == 0 and valves[elwhere]['r'] != 0:
        elcouldopen = True
    if elcouldopen and couldopen and where == elwhere:
        elcouldopen = False
    mymoves = valves[where]['ts'] if not couldopen else (valves[where]['ts'] + [None])
    elmoves = valves[elwhere]['ts'] if not elcouldopen else (valves[elwhere]['ts'] + [None])
    
    for mymove in mymoves:
        for elmove in elmoves:
            dfr = 0
            nopen = open
            if mymove == None and elmove == None:
                nmywhere = where
                nelwhere = elwhere
                nopen = open | valves[where]['bit'] | valves[elwhere]['bit']
                dfr = valves[where]['r'] + valves[elwhere]['r']
            elif mymove == None:
                nmywhere = where
                nelwhere = elmove
                nopen = open | valves[where]['bit']
                dfr = valves[where]['r']
            elif elmove == None:
                nmywhere = mymove
                nelwhere = elwhere
                nopen = open | valves[elwhere]['bit']
                dfr = valves[elwhere]['r']
            else:
                nmywhere = mymove
                nelwhere = elmove
            visit(state, (nmywhere, nelwhere, nopen), dfr = dfr)

best = 0
for k in vmax:
    pcrbest, tbest = vmax[k]
    if pcrbest > best:
        kbest = k
        best = pcrbest
while kbest is not None:
    print(kbest, vmax[kbest])
    kbest = vprev.get(kbest, None)
