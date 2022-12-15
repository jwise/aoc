#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse


d="""[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"""
d = get_data(year = 2022, day = 13)

# -1 if l < r, 1 if l > r
def compare(l, r):
    if type(l) == int and type(r) == int:
        if l < r:
            return -1
        elif l == r:
            return 0
        else:
            return 1
    elif type(l) == list and type(r) == int:
        return compare(l, [r])
    elif type(l) == int and type(r) == list:
        return compare([l], r)
    elif type(l) == list and type(r) == list:
        l = list(l)
        r = list(r)
        while len(l) != 0 and len(r) != 0:
            li = l.pop(0)
            ri = r.pop(0)
            rv = compare(li, ri)
            if rv != 0:
                return rv
        if len(l) == 0 and len(r) == 0:
            return 0
        if len(l) == 0:
            return -1
        if len(r) == 0:
            return 1

pi = 1
tot = 0
for ps in d.split('\n\n'):
    p1,p2 = [eval(p) for p in ps.split('\n')]
    print(p1, p2)
    if compare(p1, p2) == -1:
        print(pi)
        tot += pi
    pi += 1

print(tot)