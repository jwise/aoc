#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools, math
from dataclasses import *

from z3 import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 25)
else:
    d = """1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122"""

inp = { "2": 2, "1": 1, "0": 0, "-": -1, "=": -2}

nsum = 0
for l in d.split('\n'):
    n = 0
    for c in l:
        n *= 5
        n += inp[c]
    nsum += n

s = Solver()
wid = 22
base = [Int(f"n{a}") for a in range(wid)]
acc = 0
for d in range(wid):
    s.add(base[d] >= -2)
    s.add(base[d] <= 2)
    acc = acc * 5 + base[d]
s.add(acc == nsum)
print(s.check())
m = s.model()

out = ""
oup = { -2: "=", -1: "-", 0: "0", 1: "1", 2: "2" }
for d in range(wid):
    print(d, base[d], m[base[d]])
    out += oup[int(str(m[base[d]]))]
print(out)