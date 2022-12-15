#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

if True:
    d = get_data(year = 2022, day = 15)
    YWANT = 2000000
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
    YWANT=10

sens = []

for l in d.split('\n'):
    sx,sy,bx,by = extract(l)
    sens.append({"s": (sx,sy), "b": (bx,by)})
print(sens)

notpres = {}
for s in sens:
    sx,sy = s["s"]
    bx,by = s["b"]
    man = abs(sx-bx) + abs(sy-by)
    man -= abs(sy-YWANT)
    if man <= 0:
        continue
    for x in range(sx-man,sx+man+1):
        notpres[(x,YWANT)] = True

for s in sens:
    bx,by = s["b"]
    if (bx,by) in notpres:
        print("rm",(bx,by))
        del notpres[(bx,by)]

#print(sorted(list(notpres.keys())))
print(len(notpres))
