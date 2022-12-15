#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

from z3 import *

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

if True:
    d = get_data(year = 2022, day = 15)
    MAXV = 4000000
else:
    d="""Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"""
    MAXV = 20

sens = []

s = Solver()
dbx,dby = Ints('dbx dby')

def z3abs(x):
    return If(x >= 0, x, -x)

for l in d.split('\n'):
    sx,sy,bx,by = extract(l)
    s.add(Not(And(dbx == bx, dby == by)))
    man = abs(sx-bx) + abs(sy-by)
    s.add(Or(dby < sy - man,
             dby > sy + man,
             dbx < sx - man + z3abs(sy - dby),
             dbx > sx + man - z3abs(sy - dby)))
s.add(dbx >= 0)
s.add(dby >= 0)
s.add(dbx <= MAXV)
s.add(dby <= MAXV)

print(s.check())
m = s.model()
print(m[dbx].as_long() * 4000000 + m[dby].as_long())
