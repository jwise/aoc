#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse
import heapq
import functools
import math
import os

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

TIME=26

if 'TEST' not in os.environ:
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
    valves[v] = { 'r': r, 'ts': ts, 'paths': {} }
    if r != 0:
        nvalves += 1

# compute the best paths to each valve from each square node
for v in valves:
    if valves[v]['r'] == 0:
        continue
    
    vmin = {}
    vprev = {}
    q = []
    
    vmin[v] = 0
    q.append(v)
    while len(q):
        q.sort(key = lambda vv: -vmin[vv])
        vv = q.pop()
        dist = vmin[vv] + 1
        for vvv in valves[vv]['ts']:
            if vvv not in vmin:
                q.append(vvv)
                vmin[vvv] = dist
                vprev[vvv] = vv
            if dist < vmin[vvv]:
                vmin[vvv] = dist
                vprev[vvv] = vv
    for vv in vmin:
        valves[vv]['paths'][v] = vmin[vv]
print(valves)

# a graph node has state { current position, valves open, pressure committed to release?? }
vmax = {}
vprev = {}
vseen = {}

q = []
# vmax has (pressure committed to release, time)
vmax[('AA', (), 0)] = (0, 0)
heapq.heappush(q, ((0, 0), ('AA', (), 0)))

states = 0

@functools.lru_cache(maxsize = None)
def dfs(where, cvalves, timerem):
    global states
    states += 1
    if states % 1000 == 0:
        print(states, where, cvalves, timerem)
    if timerem == 0:
        return 0
    maxval = 0
    if where not in cvalves and valves[where]['r'] != 0:
        maxval = max(maxval, dfs(where, tuple(sorted(cvalves + (where,))), timerem - 1) + valves[where]['r'] * (timerem - 1))
    for nextv in valves[where]['ts']:
        maxval = max(maxval, dfs(nextv, cvalves, timerem - 1))
    return maxval

print(dfs('AA', (), TIME))
