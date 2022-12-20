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
    d = Item(int(l) * 811589153)
    inp.append(d)
    if d.v == 0:
        zero = d

print(zero, inp.index(zero))


orig = 2
for i in range(-15, 15):
    bs = [Item(' ') for d in range(8)]
    it = bs[orig]
    it.v = 'x'
    if i < 0:
        for _ in range(i, 0):
            curidx = bs.index(it)
            bs.remove(it)
            curidx -= 1
            if curidx == 0:
                curidx = len(bs)
            bs.insert(curidx, it)
    else:
        for _ in range(0, i):
            curidx = bs.index(it)
            bs.remove(it)
            if curidx == len(bs):
                curidx = 1
            else:
                curidx += 1
            bs.insert(curidx, it)

    if i < 0:
        newidx = (orig + i - 1) % (len(bs) - 1) + 1
    elif i > 0:
        newidx = (orig + i - 1) % (len(bs) - 1) + 1
    else:
        newidx = orig

    print(orig, i, bs.index(it), newidx, bs)

print("ass")

origord = list(inp)
new = list(inp)
print(new)

for _ in range(10):
    for o in origord:
        curidx = new.index(o)
#    new[curidx] = 'x'
#    while newidx <= 0:
#        newidx += len(origord) - 1
#    while newidx >= len(origord):
#        newidx -= len(origord) - 1
        orig = curidx
        i = o.v
        if i < 0:
            newidx = (orig + i - 1) % (len(origord) - 1) + 1
#        newidx = (orig + i) % (len(origord) - 1)
        elif i > 0:
            newidx = (orig + i - 1) % (len(origord) - 1) + 1
        else:
            newidx = orig

        new.remove(o)
        new.insert(newidx, o)
#    new.remove('x')
#        print(new, f"{i:2d}", orig, newidx, new.index(o))
    print(new)

print(new)
print(zero, new.index(zero))
acc = 0
for v in [1000, 2000, 3000]:
    ofs = (new.index(zero) + v) % len(new)
    print(ofs, new[ofs])
    acc += new[ofs].v

print(acc)