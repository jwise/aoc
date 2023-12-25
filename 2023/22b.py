#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq
import json

import copy

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]


d = get_data(year = 2023, day = 22)
#d = open('22.x', 'r').read()
briqs = [extract(l) for l in d.split('\n')]

def bput(map,z,y,x,briq):
    if z not in map:
        map[z] = {}
    if y not in map[z]:
        map[z][y] = {}
    if briq is None:
        del map[z][y][x]
    else:
        map[z][y][x] = briq

def bget(map,z,y,x):
    if z not in map or y not in map[z]:
        return None
    return map[z][y].get(x, None)

for bn,briq in enumerate(briqs):
    briq.append(bn)

def mkmap(briqs):
    map = {}
    for briq in briqs:
        x0,y0,z0,x1,y1,z1,bn = briq
        for x in range(x0,x1+1):
            for y in range(y0,y1+1):
                for z in range(z0,z1+1):
                    bput(map, z,y,x,briq)
    return map
map = mkmap(briqs)


# make em fall
def fall(map, briqs):
    didfall = True
    btouched = set()
    while didfall:
        didfall = 0
        for b0 in briqs:
            x0,y0,z0,x1,y1,z1,bn = b0
            if z0 == 1:
                continue
            canfall = True
            for z in range(z0, z1+1):
                for y in range(y0, y1+1):
                    for x in range(x0, x1+1):
                        if bget(map, z, y, x) != b0:
                            print("ANUS", z, y, x, b0, bget(map, z, y, x))
                            anus()
                        bunder = bget(map, z-1,y,x)
                        if bunder is not b0 and bunder is not None:
                            canfall = False
                            break
                    if not canfall:
                        break
                if not canfall:
                    break
        
            if canfall:
                for z in range(z0, z1+1):
                    for y in range(y0, y1+1):
                        for x in range(x0, x1+1):
                            bput(map, z, y, x, None)
                b0[2] -= 1
                b0[5] -= 1
                z0 -= 1
                z1 -= 1
                for z in range(z0, z1+1):
                    for y in range(y0, y1+1):
                        for x in range(x0, x1+1):
                            bput(map, z, y, x, b0)

                #print(bn, "fell", b0[2], b0[5])
                didfall += 1
                btouched.add(bn)
        #print(didfall, "fell")
    return len(btouched)

print("doing initial falling...")
nfell = fall(map, briqs)
print(f"{nfell} fell")

# look for any that could fall
print("finding choices...")
choices = []
for b0 in briqs:
    candisint = True
    for b1 in briqs:
        x0,y0,z0,x1,y1,z1,bn = b1
        if z0 == 1:
            continue
        canfall = True
        for z in range(z0, z1+1):
            for y in range(y0, y1+1):
                for x in range(x0, x1+1):
                    bunder = bget(map, z-1,y,x)
                    if bunder is not b0 and bunder is not b1 and bunder is not None:
                        canfall = False
                        break
                if not canfall:
                    break
            if not canfall:
                break
        if canfall:
            #print(f"{b0[6]} is supporting {b1[6]}")
            candisint = False
    if not candisint:
        choices.append(b0[6])

print(len(choices))

ntot = 0
for bn in choices:
    nbriqs = [[x for x in b] for b in briqs if b[6] != bn]
    nmap = mkmap(nbriqs)
    nfall = fall(nmap, nbriqs)
    print(f"{bn} -> {nfall}")
    ntot += nfall
print(ntot)
