#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse
import heapq

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

TIME=30

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
for l in d.split('\n'):
    print(l)
    v,r,ts = re.match(r"Valve (.*) has flow rate=(.*); tunnel[s]* lead[s]* to valve[s]* (.*)$", l).groups()
    r = int(r)
    ts = ts.split(', ')
    valves[v] = { 'r': r, 'ts': ts }
    if r != 0:
        nvalves += 1

# a graph node has state { current position, valves open, pressure committed to release?? }
vmax = {}
vprev = {}
vseen = {}

q = []
# vmax has (pressure committed to release, time)
vmax[('AA', (), 0)] = (0, 0)
heapq.heappush(q, ((0, 0), ('AA', (), 0)))

# delta flow rate 
def visit(cst, nst, dfr = 0):
    cwhere, copen, cpcr = cst
    nwhere, nopen = nst
    
    pcrnow, tnow = vmax[cst]
    tnow += 1
    if tnow > TIME:
        return
    pcrnow += (TIME - tnow) * dfr
    nst = (nwhere, nopen, tnow)

    if nst not in vmax:
        vmax[nst] = (-1, 0)
    pcrbest, tbest = vmax[nst]
    if pcrnow > pcrbest or (pcrnow == pcrbest and tnow < tbest):
        if len(nopen) != nvalves:
            heapq.heappush(q, ((-pcrnow, tnow), nst))
        vmax[nst] = (pcrnow, tnow)
        vprev[nst] = cst

iters = 0
while len(q):
    #q.sort(key = lambda pt: pt[2] * 60 - vmax.get(pt)[1])
    cost,state = heapq.heappop(q)
    if state in vseen:
        continue
    vseen[state] = True
    iters += 1
    if iters % 1000 == 0:
        print(iters, len(q))
    where, open, pcr = state
    #if len(open) == nvalves:
    #    continue
    #DEBUG = [
    #    ('GG', ('BB', 'DD', 'HH', 'JJ')),
    #    ('HH', ('BB', 'DD', 'HH', 'JJ'))
    #]
    #if (where, open) in DEBUG:
    #    print('ITER:', state, vmax[state])
    if where not in open and valves[where]['r'] != 0:
        visit(state, (where, tuple(sorted(open + (where,)))), dfr = valves[where]['r'])
    for nextv in valves[where]['ts']:
        visit(state, (nextv, open))

best = 0
for k in vmax:
    pcrbest, tbest = vmax[k]
    if pcrbest > best:
        kbest = k
        best = pcrbest
while kbest is not None:
    print(kbest, vmax[kbest])
    kbest = vprev.get(kbest, None)
