#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 2)
#d = open(1.x', 'r').read()

# or d.split('\n\n')
# or l.split(' ')
# or d.strip()
ls = []
for r in d.split('\n'):
    l = []
    for n in r.split(' '):
        l.append(int(n))
    ls.append(l)

nsafe = 0
for r in ls:
    lpairs = zip(r[0:-1], r[1:])
    lpairs = list(lpairs)
    safe = (all(a > b for a,b in lpairs) or all(a < b for a,b in lpairs)) and \
           (all(abs(a - b) >= 1 for a,b in lpairs)) and \
           (all(abs(a - b) <= 3 for a,b in lpairs))
    if safe:
        nsafe += 1
print(nsafe,len(ls))
