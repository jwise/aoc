#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

from z3 import *

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


maxtm = 30
def dfs(valve, vopen, cfr, time, rel):
    global maxtm
    if time > maxtm:
        maxtm = time
        print(time)
    if time == TIME:
        return rel + cfr
    
    if len(vopen) == nvalves:
        return dfs(valve, vopen, cfr, time + 1, rel + cfr)
    
    maxrel = -1
    rhere = valves[valve]['r']
    if rhere != 0 and valve not in vopen:
        maxrel = max(maxrel, dfs(valve, vopen + [valve], cfr + rhere, time + 1, rel + cfr))
    for t in valves[valve]['ts']:
        maxrel = max(maxrel, dfs(t, vopen, cfr, time + 1, rel + cfr))
    return maxrel

#print(dfs('AA', [], 0, 0, 0))

#barf()

# a graph node has state { current position, valves open, pressure committed to release?? }
vmax = {}
vprev = {}
vvis = {}

q = []
# vmax has (pressure committed to release, time)
vmax[('AA', (), 0)] = (0, 0)
vvis[('AA', (), 0)] = False
q.append(('AA', (), 0))

# delta flow rate 
def visit(cst, nst, dfr = 0):
    cwhere, copen, cpcr = cst
    nwhere, nopen = nst
    
    pcrnow, tnow = vmax[cst]
    tnow += 1
    if tnow > TIME:
        return
    pcrnow += (TIME - tnow) * dfr
    nst = (nwhere, nopen, pcrnow)

    if nst not in vmax:
        q.append(nst)
        vmax[nst] = (-1, 0)
    pcrbest, tbest = vmax[nst]
    if pcrnow > pcrbest or (pcrnow == pcrbest and tnow < tbest):
        vmax[nst] = (pcrnow, tnow)
        vprev[nst] = cst

iters = 0
while len(q):
    iters += 1
    if iters % 1000 == 0:
        print(iters, len(q))
    q.sort(key = lambda pt: pt[2] * 60 - vmax.get(pt)[1])
    state = q.pop()
    where, open, pcr = state
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
