#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse
import heapq
import functools
import math
import os
import itertools

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
    valves[v] = { 'r': r, 'ts': ts, 'paths': {}, 'bit': 1 << nvalves }
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
        if vv == v:
            continue
#        backpath = [vv]
#        vvx = vv
#        while vvx in vprev:
#            vvx = vprev[vvx]
#            backpath.append(vvx)
#        valves[vv]['paths'][v] = backpath[1:]
        valves[vv]['paths'][v] = vmin[vv]
print(valves)

#def addvalve(cvalves, *args):
#    return tuple(sorted(cvalves + args))
#
#def invalve(valve, cvalves):
#    return valve in cvalves
#
#emptyvalve = ()

def addvalve(cvalves, v):
    cvalves |= valves[v]['bit']
    return cvalves
def invalve(valve, cvalves):
    return (valves[valve]['bit'] & cvalves) != 0
emptyvalve = 0

states = 0
@functools.lru_cache(maxsize = None)
def dfs(mywhere, elwhere, mydrem, eldrem, cvalves, timerem):
    if mywhere < elwhere:
        return dfs(elwhere, mywhere, eldrem, mydrem, cvalves, timerem)

    global states
    states += 1
    if states % 1000 == 0:
        print(states, mywhere, elwhere, mydrem, eldrem, cvalves, timerem)
    if timerem == 0:
        return 0
    maxval = 0
    
    mymoves = []
    elmoves = []
    if mydrem == 0 and not invalve(mywhere, cvalves) and valves[mywhere]['r'] != 0:
        mymoves.append(True)
    if eldrem == 0 and elwhere != mywhere and not invalve(elwhere, cvalves) and valves[elwhere]['r'] != 0:
        elmoves.append(True)
    # is this correct?
    if mydrem != 0 and mydrem != None:
        mymoves.append(False)
    else:
        for nextv in valves[mywhere]['paths']:
            if not invalve(nextv, cvalves):
                mymoves.append(nextv)
    if eldrem != 0 and eldrem != None:
        elmoves.append(False)
    else:
        for nextv in valves[elwhere]['paths']:
            if not invalve(nextv, cvalves):
                elmoves.append(nextv)
    
    for mymove,elmove in itertools.product(mymoves,elmoves):
        nvalves = cvalves
        nscore = 0
        nmywhere = mywhere
        nelwhere = elwhere
        if mymove is True:
            nvalves = addvalve(nvalves, mywhere)
            nscore += valves[mywhere]['r'] * (timerem - 1)
            steplen = 1
            nmydrem = None
        elif mymove is False:
            steplen = mydrem
            nmydrem = mydrem
        else:
            nmywhere = mymove
            nmydrem = valves[mywhere]['paths'][mymove]
            steplen = nmydrem

        if elmove is True:
            nvalves = addvalve(nvalves, elwhere)
            nscore += valves[elwhere]['r'] * (timerem - 1)
            steplen = 1
            neldrem = None
        elif elmove is False:
            neldrem = eldrem
            steplen = min(steplen, neldrem)
        else:
            nelwhere = elmove
            neldrem = valves[elwhere]['paths'][elmove]
            steplen = min(steplen, neldrem)
        steplen = min(steplen, timerem)
        if neldrem is not None:
            neldrem -= steplen
        if nmydrem is not None:
            nmydrem -= steplen
        maxval = max(maxval, dfs(nmywhere, nelwhere, nmydrem, neldrem, nvalves, timerem - steplen) + nscore)
    return maxval

print(dfs('AA', 'AA', None, None, emptyvalve, TIME))
