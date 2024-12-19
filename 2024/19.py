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

d = get_data(year = 2024, day = 19)

pats = d.split('\n')[0].split(', ')

print(pats)

@functools.cache
def trypats(l):
    if l == "":
        return 1
    ways = 0
    for pat in pats:
        plen = len(pat)
        if l[:plen] == pat:
            ways += trypats(l[plen:])
    return ways

designs = 0
totways = 0

for l in d.split('\n')[2:]:
    print(l)
    ways = trypats(l)
    if ways > 0:
        designs += 1
    totways += ways

print(designs)
print(totways)