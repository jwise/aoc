#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools,itertools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 11)
#d = open('11.x', 'r').read()

gals = []
ygals = set()
xgals = set()
y = 0
x = 0
for l in d.split('\n'):
    x = 0
    for c in l:
        if c == '#':
            xgals.add(x)
            ygals.add(y)
            gals.append((y, x,))
        x += 1
    y += 1

xmap = []
ymap = []

cx = 0
for nx in range(0, x):
    xmap.append(cx)
    if nx not in xgals:
        cx += 1
    cx += 1

cy = 0
for ny in range(0, y):
    ymap.append(cy)
    if ny not in ygals:
        cy += 1
    cy += 1

print(xmap)
print(ymap)

def dist(g1, g2):
    y1,x1 = g1
    y2,x2 = g2
#    print(x1, y1, xmap[x1], ymap[y1])
#    print(x2, y2, xmap[x2], ymap[y2])
    return abs(xmap[x1] - xmap[x2]) + abs(ymap[y1] - ymap[y2])
print(gals[4], gals[8], dist(gals[4], gals[8]))

#x()
dists = 0
for g1, g2  in itertools.permutations(gals, 2):
    if g1 < g2:
        dists += dist(g1, g2)

print(dists)