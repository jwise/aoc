#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq
from itertools import combinations
from z3 import *

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 
def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 24)
#d = open('24.x', 'r').read()

s = Solver()

# typo: "rpx" in the "ints" was "rvx", and so basically I was constraining rpx == rvx, which obviously unsat.
rpx, rpy, rpz, rvx, rvy, rvz = Ints('rpx rpy rpz rvx rvy rvz')

hn = 0
for px, py, pz, vx, vy, vz in [ extract(s) for s in d.split('\n') ]:
    print(px,py,pz,vx,vy,vz)
    t = Int(f"t{hn}")
    s.add((px + vx * t) == (rpx + rvx * t))
    s.add((py + vy * t) == (rpy + rvy * t))
    s.add((pz + vz * t) == (rpz + rvz * t))
    s.add(t > 0)
    hn += 1


print(s.check())
m = s.model()
print(m[rpx].as_long() + m[rpy].as_long() + m[rpz].as_long())