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

blox = []

id = 0
free = False
for c in d.strip():
    for n in range(int(c)):
        if free:
            blox.append(None)
        else:
            blox.append(id)
    if not free:
        id += 1
    free = not free
print(blox)

while None in blox:
    gap = blox.index(None)
    blox[gap] = blox[-1]
    blox = blox[:-1]

cksm = 0
for n,fid in enumerate(blox):
    cksm += n * fid
print(cksm)