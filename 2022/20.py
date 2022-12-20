#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools
from dataclasses import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 20)
else:
    d = """1
2
-3
3
-2
0
4"""

@dataclass(unsafe_hash = True, eq = False)
class Item:
    v: int
    
    def __repr__(self):
        return f"[{self.v}]"

inp = []
for l in d.split('\n'):
    d = Item(int(l))
    inp.append(d)
    if d.v == 0:
        zero = d

print(zero, inp.index(zero))

origord = list(inp)
new = list(inp)
print(new)
for o in origord:
    curidx = new.index(o)
    new.remove(o)
    newidx = curidx + o.v
    while newidx <= 0:
        newidx += len(origord) - 1
    while newidx >= len(origord):
        newidx -= len(origord) - 1
    new.insert(newidx, o)
#    print(new)

print(zero, new.index(zero))
acc = 0
for v in [1000, 2000, 3000]:
    ofs = (new.index(zero) + v) % len(new)
    print(ofs, new[ofs])
    acc += new[ofs].v

print(acc)