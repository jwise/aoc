#!/usr/bin/env pypy3

from collections import *
import math
import re, parse,functools, heapq,itertools
import sys

k1x, k1y = 2,0
k2x, k2y = 2,0
k3x, k3y = 2,3

xmap = {"^":(-1,0), "v":(1,0), "<":(0,-1), ">":(0,1)}

k1map = {(0,1): "^", (0,2): "A", (1,0): "<", (1,1):"v", (1,2):">"}
k2map = {(0,1): "^", (0,2): "A", (1,0): "<", (1,1):"v", (1,2):">"}
k3map = {(0,0): "7", (0,1): "8", (0,2): "9", (1,0):"4", (1,1):"5", (1,2):"6", (2,0):"1", (2,1):"2", (2,2):"3",(3,1):"0",(3,2):"A"}

inp = sys.argv[1]

k1inp = ""

print(inp)

for c in inp:
    assert((k1y, k1x) in k1map)
    if c == "A":
        k1inp += k1map[(k1y, k1x)]
    else:
        dy,dx = xmap[c]
        k1y += dy
        k1x += dx

print(k1inp)

k2inp = ""
for c in k1inp:
    assert((k2y, k2x) in k2map)
    if c == "A":
        k2inp += k2map[(k2y, k2x)]
    else:
        dy,dx = xmap[c]
        k2y += dy
        k2x += dx
print(k2inp)

k3inp = ""
for c in k2inp:
    assert((k3y, k3x) in k3map)
    print(c)
    if c == "A":
        k3inp += k3map[(k3y, k3x)]
    else:
        dy,dx = xmap[c]
        k3y += dy
        k3x += dx
print(k3inp)
