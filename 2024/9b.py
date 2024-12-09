#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 9)

files = {}
gaps = []
bloq = 0

id = 0
free = False
for c in d.strip():
    if not free:
        files[id] = (bloq, int(c))
    else:
        gaps.append((bloq, int(c)))
    bloq += int(c)
    if not free:
        id += 1
    free = not free
print(files)

for xid in range(id-1,-1,-1):
    cbloq, sz = files[xid]
    for n,(gapbloq,gapsz) in enumerate(gaps):
        if gapsz >= sz and gapbloq < cbloq:
            #print(f"moving file {xid} into gap at {gapbloq} of size {gapsz}
            files[xid] = (gapbloq, sz)
            gaps[n] = (gapbloq+sz, gapsz-sz)
            break
cksm = 0
for fid,(bloq,sz) in files.items():
    for i in range(sz):
        cksm += (bloq + i) * fid
print(cksm)